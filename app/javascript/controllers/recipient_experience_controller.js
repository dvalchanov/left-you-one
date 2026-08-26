import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "arrival",
    "reveal",
    "possession",
    "journey",
    "openButton",
    "skipButton",
    "revealedHeading",
    "liveRegion",
    "passPlaceholder"
  ]

  static values = {
    initialState: String,
    reducedMotion: Boolean
  }

  connect() {
    this.timers = []
    this.mediaQuery = window.matchMedia("(prefers-reduced-motion: reduce)")
    this.handleVisibility = this.handleVisibility.bind(this)
    this.handleMessage = this.handleMessage.bind(this)
    this.handlePointerMove = this.handlePointerMove.bind(this)

    document.addEventListener("visibilitychange", this.handleVisibility)
    window.addEventListener("message", this.handleMessage)
    this.element.addEventListener("pointermove", this.handlePointerMove, { passive: true })

    this.applyState(this.initialStateValue || "arrival")
    this.handleVisibility()
  }

  disconnect() {
    this.clearTimers()
    document.removeEventListener("visibilitychange", this.handleVisibility)
    window.removeEventListener("message", this.handleMessage)
    this.element.removeEventListener("pointermove", this.handlePointerMove)
  }

  open() {
    if (this.element.dataset.state !== "arrival") return

    this.clearTimers()
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

    this.after(420, () => { this.arrivalTarget.hidden = true })
    this.after(760, () => this.showReveal())
    this.after(1_850, () => this.showPossession())
  }

  skip() {
    this.finishOpening()
  }

  showPassPlaceholder() {
    this.passPlaceholderTarget.hidden = false
    this.passPlaceholderTarget.focus?.()
    this.announce(this.passPlaceholderTarget.textContent.trim())
  }

  handleMessage(event) {
    if (event.origin !== window.location.origin) return

    if (event.data?.type === "recipient:open") this.open()
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
    this.setVisibility(this.possessionTarget, possessionVisible)
    this.setVisibility(this.journeyTarget, journeyVisible)
    this.skipButtonTarget.hidden = state !== "opening"
  }

  showReveal() {
    this.element.dataset.state = "revealed"
    this.skipButtonTarget.hidden = true
    this.revealedHeadingTarget.focus({ preventScroll: true })
    this.announce(this.translation("revealed"))
  }

  showPossession() {
    this.setVisibility(this.possessionTarget, true)
    this.element.dataset.state = "with_you"
  }

  finishOpening() {
    this.clearTimers()
    this.arrivalTarget.hidden = true
    this.setVisibility(this.revealTarget, true)
    this.setVisibility(this.possessionTarget, true)
    this.skipButtonTarget.hidden = true
    this.element.dataset.state = "with_you"
    this.revealedHeadingTarget.focus({ preventScroll: true })
    this.announce(this.translation("revealed"))
  }

  setVisibility(target, visible) {
    target.hidden = !visible
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
