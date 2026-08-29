import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["copySource", "status"]
  static values = { shareText: String }

  async copy(event) {
    const source = this.hasCopySourceTarget ? this.copySourceTarget : null
    const value = event?.currentTarget?.dataset.copyValue || source?.value
    if (!value) return

    try {
      await navigator.clipboard.writeText(value)
      this.showStatus("Link copied.")
    } catch (_error) {
      source?.select()
      this.showStatus("Copying was blocked. The link is selected instead.")
    }
  }

  async share() {
    if (!this.hasCopySourceTarget) return
    if (!navigator.share) return this.copy()

    try {
      await navigator.share({
        text: this.hasShareTextValue ? this.shareTextValue : undefined,
        url: this.copySourceTarget.value
      })
    } catch (_error) {
      // Closing the native share sheet is not an error the experience needs to announce.
    }
  }

  showStatus(message) {
    if (this.hasStatusTarget) this.statusTarget.textContent = message
  }
}
