require "rails_helper"

RSpec.describe "Recipient preview", type: :system do
  before do
    driven_by(:selenium, using: :headless_chrome, screen_size: [ 1_280, 800 ])

    create(
      :gift_template,
      source_key: "recipient_system_preview",
      main_text: "A little courage before your doubts wake up.",
      context_text: "For the thing you’ve been putting off.",
      ritual_text: "Keep it until you begin.",
      visual_family: "luminous",
      finish: "soft_grain",
      background_key: "first_light_window"
    )
  end

  let(:template) { GiftTemplate.find_by!(source_key: "recipient_system_preview") }

  it "opens by keyboard, reveals in place, and moves focus to the gift" do
    visit dev_recipient_preview_path(template: template.source_key)

    expect(page).to have_text("Dimitar left you one.")
    find("button", text: I18n.t("recipient.open")).send_keys(:enter)

    expect(page).to have_text(template.main_text)
    expect(page).to have_text(I18n.t("holder.possession"), wait: 3)
    expect(page.evaluate_script("document.activeElement.id")).to eq("revealed-gift-heading")
  end

  it "settles immediately when reduced motion is simulated" do
    visit dev_recipient_preview_path(template: template.source_key, reduced_motion: "1")

    click_button I18n.t("recipient.open")

    expect(page).to have_css("[data-reduced-motion='true'][data-state='with_you']")
    expect(page).to have_text(template.main_text)
    expect(page.evaluate_script("document.activeElement.id")).to eq("revealed-gift-heading")
    expect(page.evaluate_script("getComputedStyle(document.querySelector('.recipient-experience'), '::before').animationName")).to eq("none")
  end

  it "keeps the experience usable at a mobile viewport" do
    page.current_window.resize_to(390, 844)
    visit dev_recipient_preview_path(template: template.source_key, state: "with_you", long_text: "1")

    expect(page).to have_css(".recipient-stage")
    expect(page).to have_text(RecipientPreview::LONG_MAIN_TEXT)
    expect(page).to have_button(I18n.t("recipient.pass_action"))
  end

  it "shows the existing journey without turning it into a dashboard" do
    visit dev_recipient_preview_path(
      template: template.source_key,
      state: "existing_journey",
      sender: "Maya",
      places: "Sofia, Vienna, Berlin",
      holder_count: "7",
      days: "19"
    )

    expect(page).to have_text("Sofia → Vienna → Berlin")
    expect(page).to have_text(/7 people · 3 countries · 19 days/i)
    expect(page).not_to have_css("nav, canvas, [data-map]")
  end

  it "replays the clean experience from the laboratory without changing domain state" do
    counts = [ Gift.count, Transfer.count, JourneyStop.count ]
    visit dev_recipient_lab_path(template: template.source_key)

    within_frame(find("iframe")) do
      expect(page).to have_text("Dimitar left you one.")
    end

    fill_in I18n.t("prototype.recipient_lab.sender"), with: "Maya"

    within_frame(find("iframe")) do
      expect(page).to have_text("Maya left you one.")
    end

    click_button I18n.t("prototype.recipient_lab.open")

    within_frame(find("iframe")) do
      expect(page).to have_text(template.main_text)
    end

    click_button I18n.t("prototype.recipient_lab.jump")

    within_frame(find("iframe")) do
      expect(page).to have_css("[data-state='revealed']")
    end

    expect([ Gift.count, Transfer.count, JourneyStop.count ]).to eq(counts)
  end

  it "applies the intended treatment when a visual family changes" do
    visit dev_recipient_lab_path(template: template.source_key)

    select "Paper World", from: I18n.t("prototype.recipient_lab.family")

    within_frame(find("iframe")) do
      expect(page).to have_css(".tone-dark.overlay-paper_edge img[src*='paper-world']")
    end
  end
end
