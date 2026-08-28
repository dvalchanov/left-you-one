require "rails_helper"
require "uri"

RSpec.describe "Core gift flow", type: :system do
  before do
    driven_by(:selenium, using: :headless_chrome, screen_size: [ 1_280, 800 ])

    create(
      :gift_template,
      source_key: "system_core_flow",
      theme: "calm",
      main_text: "Ten quiet minutes with nothing to prove.",
      context_text: "For the day that will not stop asking things of you.",
      ritual_text: "Use them slowly.",
      visual_family: "luminous",
      finish: "soft_grain",
      background_key: "afterglow_meadow"
    )
  end

  it "carries one stable gift from sender discovery into an isolated recipient opening" do
    visit start_path
    find("label", text: /Calm/).click
    click_button "Find one"

    expect(page).to have_text("We found something.")
    gift = Gift.order(:created_at).last
    expect(page).to have_css(".family-paper_world, .recipient-experience")

    find("button", text: "Open it").send_keys(:enter)
    expect(page).to have_text(gift.gift_template.main_text, wait: 4)
    expect(page).to have_link("Someone came to mind", wait: 4)
    expect(gift.reload.opened_by_creator_at).to be_present

    click_link "Someone came to mind"
    fill_in "Your name", with: "Dimitar"
    fill_in "Their first name or nickname", with: "Anna"
    fill_in "Why did they come to mind?", with: "For the morning you mentioned."
    click_button "See what they’ll open"

    expect(page).to have_text("You saw this and thought of Anna.")
    click_button "Leave this for Anna · $2"
    expect(page).to have_text("It’s sealed and waiting for Anna.")
    claim_url = find("[data-flow-target='copySource']").value
    sender_manage_path = page.current_path

    Capybara.using_session(:recipient) do
      visit URI(claim_url).request_uri

      expect(page).to have_text("Dimitar left you something.")
      expect(page).not_to have_text(gift.gift_template.main_text)
      find("button", text: "Open it").send_keys(:enter)

      expect(page).to have_text(gift.gift_template.main_text, wait: 5)
      expect(page).to have_text("For the morning you mentioned.")
      expect(page).to have_text("It’s with you now.", wait: 5)
      expect(page.current_path).to eq(public_gift_path(gift.public_slug))

      fill_in "Display name", with: "Anna"
      fill_in "City", with: "Sofia"
      fill_in "Country code", with: "BG"
      click_button "Add my mark"
      expect(page).to have_text("Anna · Sofia · BG")
    end

    visit sender_manage_path
    expect(page).to have_text("Anna opened the gift you started.")
    expect(gift.reload.journey_stops.count).to eq(1)
  end

  it "keeps the central flow usable at phone width with reduced motion" do
    emulate_phone_viewport
    page.driver.browser.execute_cdp(
      "Emulation.setEmulatedMedia",
      features: [ { name: "prefers-reduced-motion", value: "reduce" } ]
    )

    visit start_path
    expect(page).to have_css(".theme-grid")
    find("label", text: /Calm/).click
    click_button "Find one"
    click_button "Open it"

    expect(page).to have_link("Someone came to mind")
    click_link "Someone came to mind"
    fill_in "Your name", with: "Dimitar"
    fill_in "Their first name or nickname", with: "Anna"
    click_button "See what they’ll open"
    click_button "Leave this for Anna · $2"

    claim_url = find("[data-flow-target='copySource']").value
    Capybara.using_session(:mobile_recipient) do
      emulate_phone_viewport
      page.driver.browser.execute_cdp(
        "Emulation.setEmulatedMedia",
        features: [ { name: "prefers-reduced-motion", value: "reduce" } ]
      )
      visit URI(claim_url).request_uri
      click_button "Open it"

      expect(page).to have_text("It’s with you now.")
      expect(page).to have_css("[data-state='with_you'][data-reduced-motion='false']")
      expect(page.evaluate_script("document.documentElement.clientWidth")).to eq(390)
      expect(page.evaluate_script("document.documentElement.scrollWidth")).to be <= 390
    end
  end

  it "lets one isolated browser claim and gives the other the already-claimed state" do
    raw_claim_token = "system duplicate claim"
    gift = create(
      :gift,
      gift_template: GiftTemplate.find_by!(source_key: "system_core_flow"),
      state: "waiting_for_claim",
      visual_configuration: GiftVisuals::PrototypeDefault.snapshot_for(GiftTemplate.find_by!(source_key: "system_core_flow"))
    )
    create(
      :transfer,
      gift:,
      state: "pending",
      claim_token_digest: CapabilityToken.digest(raw_claim_token),
      source_holder_generation: 0
    )

    Capybara.using_session(:first_claimant) do
      visit open_claim_path(raw_claim_token)
      expect(page).to have_css("[data-recipient-experience-ready='true']")
      find("button", text: "Open it").send_keys(:enter)
      expect(page).to have_text("It’s with you now.", wait: 5)
    end

    Capybara.using_session(:second_claimant) do
      visit open_claim_path(raw_claim_token)
      expect(page).to have_text("This one has already found someone.")
      expect(page).to have_link("View its journey")
    end

    expect(gift.reload).to have_attributes(state: "held", holder_generation: 1)
    expect(gift.journey_stops.count).to eq(1)
  end

  def emulate_phone_viewport
    page.driver.browser.execute_cdp(
      "Emulation.setDeviceMetricsOverride",
      width: 390,
      height: 844,
      deviceScaleFactor: 1,
      mobile: true
    )
  end
end
