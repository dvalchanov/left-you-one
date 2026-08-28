import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "frame", "family", "background", "composition", "motion", "grain", "overlay", "textTone", "template", "state", "mobile", "device", "status", "previewLabel"]
  static values = {
    previewUrl: String,
    labUrl: String,
    defaultUrl: String,
    copiedMessage: String,
    copyFailedMessage: String,
    defaultSavedMessage: String
  }

  connect() {
    this.refreshTimer = null
    this.pendingOpen = false
    this.frameReady = this.frameTarget.contentDocument?.readyState === "complete"
    this.updateDevice()
  }

  disconnect() {
    window.clearTimeout(this.refreshTimer)
  }

  scheduleRefresh(event) {
    window.clearTimeout(this.refreshTimer)

    const typingField = event.target.matches("input[type='text'], input[type='number'], textarea")
    this.refreshTimer = window.setTimeout(() => this.refreshFrame(), typingField ? 280 : 0)
  }

  refreshFrame(event) {
    event?.preventDefault()
    window.clearTimeout(this.refreshTimer)
    const cleanUrl = this.cleanUrl()

    if (this.frameTarget.src !== cleanUrl) {
      this.frameReady = false
      this.frameTarget.src = cleanUrl
    }

    this.updateDevice()
    window.history.replaceState({}, "", this.labUrl())
  }

  familyChanged() {
    const option = this.familyTarget.selectedOptions[0]
    if (option?.dataset.background) this.backgroundTarget.value = option.dataset.background
    this.applyBackgroundDefaults()
  }

  backgroundChanged() {
    this.applyBackgroundDefaults()
  }

  reset() {
    window.location.assign(this.labUrlValue)
  }

  openGift() {
    if (!this.frameReady) {
      this.pendingOpen = true
      return
    }

    this.sendOpenMessage()
  }

  frameLoaded() {
    this.frameReady = true
    const experience = this.frameTarget.contentDocument?.querySelector("[data-controller='recipient-experience']")
    if (experience?.dataset.visualLabel) this.previewLabelTarget.textContent = experience.dataset.visualLabel

    if (this.pendingOpen) {
      this.pendingOpen = false
      this.sendOpenMessage()
    }
  }

  jumpToRevealed() {
    this.stateTarget.value = "revealed"
    this.refreshFrame()
  }

  switchTemplate() {
    const options = Array.from(this.templateTarget.options)
    this.templateTarget.selectedIndex = (this.templateTarget.selectedIndex + 1) % options.length
    this.stateTarget.value = "arrival"
    this.refreshFrame()
  }

  randomize() {
    this.randomSelect(this.familyTarget)
    this.familyChanged()
    this.randomSelect(this.backgroundTarget)

    this.formTarget.querySelectorAll("select[name='composition'], select[name='sealed_treatment'], select[name='motion'], select[name='grain'], select[name='overlay'], select[name='text_tone']")
      .forEach((select) => this.randomSelect(select))

    this.stateTarget.value = "arrival"
    this.refreshFrame()
  }

  openClean() {
    window.open(this.cleanUrl(), "_blank", "noopener")
  }

  async copyUrl() {
    try {
      await navigator.clipboard.writeText(this.cleanUrl())
      this.statusTarget.textContent = this.copiedMessageValue
    } catch (_error) {
      this.statusTarget.textContent = this.copyFailedMessageValue
    }
  }

  async saveDefault() {
    const params = new URLSearchParams(new FormData(this.formTarget))
    const csrf = document.querySelector("meta[name='csrf-token']")?.content

    try {
      const response = await window.fetch(this.defaultUrlValue, {
        method: "POST",
        credentials: "same-origin",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
          ...(csrf ? { "X-CSRF-Token": csrf } : {})
        },
        body: params.toString()
      })
      if (!response.ok) throw new Error("save failed")
      this.statusTarget.textContent = this.defaultSavedMessageValue
    } catch (_error) {
      this.statusTarget.textContent = this.copyFailedMessageValue
    }
  }

  updateDevice() {
    this.deviceTarget.classList.toggle("is-mobile", this.mobileTarget.checked)
  }

  cleanUrl() {
    const url = new URL(this.previewUrlValue, window.location.origin)
    const params = new URLSearchParams(new FormData(this.formTarget))
    params.delete("mobile")
    url.search = params.toString()
    return url.toString()
  }

  labUrl() {
    const url = new URL(this.labUrlValue, window.location.origin)
    url.search = new URLSearchParams(new FormData(this.formTarget)).toString()
    return url.toString()
  }

  randomSelect(select) {
    if (select.options.length === 0) return
    select.selectedIndex = Math.floor(Math.random() * select.options.length)
  }

  applyBackgroundDefaults() {
    const defaults = this.backgroundTarget.selectedOptions[0]?.dataset
    if (!defaults) return

    this.compositionTarget.value = defaults.composition
    this.motionTarget.value = defaults.motion
    this.grainTarget.value = defaults.grain
    this.overlayTarget.value = defaults.overlay
    this.textToneTarget.value = defaults.textTone
  }

  sendOpenMessage() {
    const frameWindow = this.frameTarget.contentWindow
    const experience = this.frameTarget.contentDocument?.querySelector("[data-controller='recipient-experience']")
    const controller = frameWindow?.Stimulus?.getControllerForElementAndIdentifier(experience, "recipient-experience")

    if (controller) {
      controller.openFromLab()
    } else {
      frameWindow?.postMessage({ type: "recipient:open" }, window.location.origin)
    }
  }
}
