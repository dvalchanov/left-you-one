import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "frame", "family", "background", "composition", "motion", "grain", "overlay", "textTone", "template", "state", "mobile", "device", "status"]
  static values = { previewUrl: String, labUrl: String, copiedMessage: String, copyFailedMessage: String }

  connect() {
    this.refreshTimer = null
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
    this.frameTarget.src = this.cleanUrl()
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
    this.frameTarget.contentWindow?.postMessage({ type: "recipient:open" }, window.location.origin)
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
}
