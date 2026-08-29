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

    expect(page).to have_text("Dimitar left you something.")
    expect(page).to have_text("They wanted you to have it.")
    find("button", text: I18n.t("recipient.open")).send_keys(:enter)

    expect(page).to have_text(template.main_text, wait: 4)
    expect(page).to have_text(I18n.t("holder.possession"), wait: 4)
    expect(page.evaluate_script("document.activeElement.id")).to eq("revealed-gift-heading")
  end

  it "turns a deliberate pointer hold into the opening transition" do
    visit dev_recipient_preview_path(template: template.source_key)

    page.execute_script(<<~JAVASCRIPT)
      document.querySelector(".recipient-open").dispatchEvent(
        new PointerEvent("pointerdown", { bubbles: true, pointerId: 1 })
      )
    JAVASCRIPT

    expect(page).to have_text(template.main_text, wait: 4)
    expect(page).to have_css("[data-state='with_you']", wait: 4)
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
    expect(page).not_to have_button("This made me think of someone")
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

  it "keeps the revealed gift fixed when possession settles in" do
    [ [ 1_280, 800 ], [ 390, 844 ] ].each do |width, height|
      page.current_window.resize_to(width, height)
      visit dev_recipient_preview_path(
        template: template.source_key,
        state: "revealed",
        reduced_motion: "1"
      )

      expect(page).to have_css("[data-state='revealed']")
      expect(page).to have_css(".recipient-possession[aria-hidden='true']", visible: :hidden)

      before_top = page.evaluate_script("document.querySelector('.recipient-gift__main').getBoundingClientRect().top")
      reserved_height = page.evaluate_script("document.querySelector('.recipient-possession').getBoundingClientRect().height")

      page.execute_script(<<~JAVASCRIPT)
        window.Stimulus.getControllerForElementAndIdentifier(
          document.querySelector("[data-controller='recipient-experience']"),
          "recipient-experience"
        ).showPossession()
      JAVASCRIPT

      expect(page).to have_css("[data-state='with_you']")
      after_top = page.evaluate_script("document.querySelector('.recipient-gift__main').getBoundingClientRect().top")

      expect(reserved_height).to be_positive
      expect(after_top).to be_within(0.5).of(before_top)
    end
  end

  it "replays the clean experience from the laboratory without changing domain state" do
    counts = [ Gift.count, Transfer.count, JourneyStop.count ]
    visit dev_recipient_lab_path(template: template.source_key)

    within_frame(find("iframe")) do
      expect(page).to have_text("Dimitar left you something.")
    end

    fill_in I18n.t("prototype.recipient_lab.sender"), with: "Maya"

    within_frame(find("iframe")) do
      expect(page).to have_text("Maya left you something.")
    end

    find("[data-action='recipient-lab#openGift']").click

    within_frame(find("iframe")) do
      expect(page).to have_text(template.main_text, wait: 4)
    end

    click_button I18n.t("prototype.recipient_lab.jump")

    within_frame(find("iframe")) do
      expect(page).to have_css("[data-state='revealed']")
    end

    expect([ Gift.count, Transfer.count, JourneyStop.count ]).to eq(counts)
  end

  it "switches the laboratory into the sender's pre-commitment point of view" do
    visit dev_recipient_lab_path(template: template.source_key)

    select I18n.t("prototype.recipient_lab.viewers.sender"), from: I18n.t("prototype.recipient_lab.viewer")
    select I18n.t("prototype.recipient_lab.states.with_you"), from: I18n.t("prototype.recipient_lab.state")

    within_frame(find("iframe")) do
      expect(page).to have_text("You saw this and thought of Anna.")
      expect(page).to have_button("Leave this for Anna · $2")
      expect(page).to have_text(I18n.t("prototype.notice"))
    end
  end

  it "applies the intended treatment when a visual family changes" do
    visit dev_recipient_lab_path(template: template.source_key)

    select "Paper World", from: I18n.t("prototype.recipient_lab.family")

    within_frame(find("iframe")) do
      expect(page).to have_css(".tone-dark.overlay-paper_edge img[src*='paper-world']")
    end
  end
end
