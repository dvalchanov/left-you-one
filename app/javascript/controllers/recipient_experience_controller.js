import { Controller } from "@hotwired/stimulus"

// Timing for the opening ceremony. The hold itself is the anticipation; once it
// completes, the gift is given room to be felt before possession settles in.
const FILL_MS = 1050
const REWIND_MS = 420
const HIDE_ARRIVAL_MS = 380
const SHOW_REVEAL_MS = 720
const SHOW_POSSESSION_MS = 2600

export default class extends Controller {
  static targets = [
    "arrival",
    "reveal",
    "possession",
    "journey",
    "openButton",
    "openHint",
    "skipButton",
    "revealedHeading",
    "liveRegion",
    "passPlaceholder",
    "openForm"
  ]

  static values = {
    initialState: String,
    reducedMotion: Boolean,
    revealUrl: String
  }

  connect() {
    this.timers = []
    this.progress = 0
    this.holding = false
    this.autoFilling = false
    this.opened = false
    this.rafId = null
    this.lastFrame = 0

    this.mediaQuery = window.matchMedia("(prefers-reduced-motion: reduce)")
    this.handleVisibility = this.handleVisibility.bind(this)
    this.handleMessage = this.handleMessage.bind(this)
    this.handlePointerMove = this.handlePointerMove.bind(this)
    this.updateMotionAffordance = this.updateMotionAffordance.bind(this)
    this.tick = this.tick.bind(this)

    document.addEventListener("visibilitychange", this.handleVisibility)
    window.addEventListener("message", this.handleMessage)
    this.element.addEventListener("pointermove", this.handlePointerMove, { passive: true })
    this.mediaQuery.addEventListener("change", this.updateMotionAffordance)

    this.updateMotionAffordance()
    this.applyState(this.initialStateValue || "arrival")
    if (this.initialStateValue === "opening") this.resumeClaimedOpening()
    this.handleVisibility()
    this.element.dataset.recipientExperienceReady = "true"
  }

  disconnect() {
    this.clearTimers()
    this.stopLoop()
    document.removeEventListener("visibilitychange", this.handleVisibility)
    window.removeEventListener("message", this.handleMessage)
    this.element.removeEventListener("pointermove", this.handlePointerMove)
    this.mediaQuery.removeEventListener("change", this.updateMotionAffordance)
  }

  // --- Pointer hold -------------------------------------------------------

  holdStart(event) {
    if (this.element.dataset.state !== "arrival" || this.opened) return
    event.preventDefault()

    if (this.motionIsReduced()) {
      this.open()
      return
    }

    this.holding = true
    this.hasOpenButton && this.openButtonTarget.classList.add("is-holding")
    try {
      this.openButtonTarget.setPointerCapture(event.pointerId)
    } catch (_error) {
      // pointer capture is a nicety, not a requirement
    }
    this.startLoop()
  }

  holdEnd() {
    if (!this.holding) return
    this.holding = false
    this.openButtonTarget.classList.remove("is-holding")
    // the loop keeps running to rewind the world back to sealed
    this.startLoop()
  }

  // --- Keyboard -----------------------------------------------------------

  keyDown(event) {
    if (event.key !== "Enter" && event.key !== " " && event.key !== "Spacebar") return
    event.preventDefault()
    if (event.repeat) return
    this.open()
  }

  // --- Opening ------------------------------------------------------------

  // Programmatic open: keyboard activation or the reduced-motion path. It
  // self-drives the warm fill so both routes reach the same reveal.
  open() {
    if (this.element.dataset.state !== "arrival" || this.opened) return

    if (this.motionIsReduced()) {
      this.setProgress(1)
      this.completeReveal()
      return
    }

    this.autoFilling = true
    this.startLoop()
  }

  // The development laboratory may be embedded outside the visible viewport,
  // where browsers throttle requestAnimationFrame. Begin after the hold has
  // completed so the reveal sequence remains replayable there.
  openFromLab() {
    if (this.element.dataset.state !== "arrival" || this.opened) return

    this.setProgress(1)
    this.completeReveal()
  }

  skip() {
    this.finishOpening()
  }

  tick(now) {
    const dt = this.lastFrame ? now - this.lastFrame : 16
    this.lastFrame = now

    if (this.holding || this.autoFilling) {
      this.setProgress(this.progress + dt / FILL_MS)
    } else {
      this.setProgress(this.progress - dt / REWIND_MS)
    }

    if (this.progress >= 1 && (this.holding || this.autoFilling)) {
      this.completeReveal()
      return
    }

    if (this.progress <= 0 && !this.holding && !this.autoFilling) {
      this.stopLoop()
      return
    }

    this.rafId = window.requestAnimationFrame(this.tick)
  }

  completeReveal() {
    if (this.opened) return
    this.opened = true
    this.holding = false
    this.autoFilling = false
    this.stopLoop()
    this.setProgress(1)
    this.hasOpenButton && this.openButtonTarget.classList.remove("is-holding")

    if (this.hasOpenFormTarget) {
      this.element.dataset.state = "opening"
      this.announce(this.translation("opening"))
      this.openFormTarget.requestSubmit()
      return
    }

    this.recordReveal()

    this.element.dataset.state = "opening"
    this.arrivalTarget.setAttribute("aria-hidden", "true")
    this.revealTarget.hidden = false
    this.revealTarget.setAttribute("aria-hidden", "false")
    this.skipButtonTarget.hidden = false
    this.announce(this.translation("opening"))

    if (this.motionIsReduced()) {
      this.finishOpening()
      return
    }

    this.after(HIDE_ARRIVAL_MS, () => { this.arrivalTarget.hidden = true })
    this.after(SHOW_REVEAL_MS, () => this.showReveal())
    this.after(SHOW_POSSESSION_MS, () => this.showPossession())
  }

  showPassPlaceholder() {
    this.passPlaceholderTarget.hidden = false
    this.passPlaceholderTarget.focus?.()
    this.announce(this.passPlaceholderTarget.textContent.trim())
  }

  resumeClaimedOpening() {
    if (this.motionIsReduced()) {
      this.finishOpening()
      return
    }

    this.after(SHOW_REVEAL_MS, () => this.showReveal())
    this.after(SHOW_POSSESSION_MS, () => this.showPossession())
  }

  recordReveal() {
    if (!this.hasRevealUrlValue || !this.revealUrlValue) return

    const csrf = document.querySelector("meta[name='csrf-token']")?.content
    window.fetch(this.revealUrlValue, {
      method: "POST",
      credentials: "same-origin",
      headers: csrf ? { "X-CSRF-Token": csrf } : {}
    }).catch(() => {})
  }

  handleMessage(event) {
    if (event.origin !== window.location.origin) return

    if (event.data?.type === "recipient:open") this.openFromLab()
  }

  handleVisibility() {
    this.element.dataset.paused = document.hidden ? "true" : "false"
  }

  handlePointerMove(event) {
    if (this.motionIsReduced() || !this.element.classList.contains("motion-slight_parallax")) return

    const bounds = this.element.getBoundingClientRect()
    const x = ((event.clientX - bounds.left) / bounds.width - 0.5) * 6
    const y = ((event.clientY - bounds.top) / bounds.height - 0.5) * 6
    this.element.style.setProperty("--parallax-x", `${x}px`)
    this.element.style.setProperty("--parallax-y", `${y}px`)
  }

  applyState(state) {
    const revealVisible = ["opening", "revealed", "with_you", "existing_journey"].includes(state)
    const possessionVisible = ["with_you", "existing_journey"].includes(state)
    const journeyVisible = state === "existing_journey"

    this.element.dataset.state = state
    this.setVisibility(this.arrivalTarget, state === "arrival")
    this.setVisibility(this.revealTarget, revealVisible)
    this.setVisibility(this.possessionTarget, possessionVisible, { reserveSpace: true })
    this.setVisibility(this.journeyTarget, journeyVisible)
    this.skipButtonTarget.hidden = state !== "opening"

    if (state === "arrival") {
      this.opened = false
      this.setProgress(0)
      this.element.style.removeProperty("--op")
    } else {
      this.opened = true
      this.element.style.setProperty("--op", "1")
      this.element.style.setProperty("--hold", "1")
    }
  }

  showReveal() {
    this.element.dataset.state = "revealed"
    this.skipButtonTarget.hidden = true
    this.revealedHeadingTarget.focus({ preventScroll: true })
    this.announce(this.translation("revealed"))
  }

  showPossession() {
    this.setVisibility(this.possessionTarget, true, { reserveSpace: true })
    this.element.dataset.state = "with_you"
  }

  finishOpening() {
    this.clearTimers()
    this.opened = true
    this.setProgress(1)
    this.arrivalTarget.hidden = true
    this.setVisibility(this.revealTarget, true)
    this.setVisibility(this.possessionTarget, true, { reserveSpace: true })
    this.skipButtonTarget.hidden = true
    this.element.dataset.state = "with_you"
    this.revealedHeadingTarget.focus({ preventScroll: true })
    this.announce(this.translation("revealed"))
  }

  // --- Progress plumbing --------------------------------------------------

  setProgress(value) {
    this.progress = Math.min(1, Math.max(0, value))
    const eased = this.progress * this.progress * (3 - 2 * this.progress)
    this.element.style.setProperty("--op", eased.toFixed(4))
    this.element.style.setProperty("--hold", this.progress.toFixed(4))
  }

  startLoop() {
    if (this.rafId) return
    this.lastFrame = 0
    this.rafId = window.requestAnimationFrame(this.tick)
  }

  stopLoop() {
    if (this.rafId) window.cancelAnimationFrame(this.rafId)
    this.rafId = null
    this.lastFrame = 0
  }

  // Keep the opening affordance in sync with the current motion preference.
  // Reduced motion turns the same "Open it" action into an immediate click and
  // removes the otherwise inaccurate hold instruction from the accessibility tree.
  updateMotionAffordance() {
    if (!this.hasOpenButtonTarget || !this.hasOpenHintTarget) return

    const reduced = this.motionIsReduced()
    this.openHintTarget.hidden = reduced

    if (reduced) {
      this.openButtonTarget.removeAttribute("aria-describedby")
    } else {
      this.openButtonTarget.setAttribute("aria-describedby", this.openHintTarget.id)
    }
  }

  get hasOpenButton() {
    return this.hasOpenButtonTarget
  }

  setVisibility(target, visible, { reserveSpace = false } = {}) {
    target.hidden = reserveSpace ? false : !visible
    target.setAttribute("aria-hidden", visible ? "false" : "true")
  }

  announce(message) {
    this.liveRegionTarget.textContent = message
  }

  translation(key) {
    return this.element.dataset[key]
  }

  motionIsReduced() {
    return this.reducedMotionValue || this.mediaQuery.matches
  }

  after(delay, callback) {
    this.timers.push(window.setTimeout(callback, delay))
  }

  clearTimers() {
    this.timers.forEach((timer) => window.clearTimeout(timer))
    this.timers = []
  }
}
