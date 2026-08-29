require "rails_helper"

RSpec.describe "Landing page", type: :system do
  before do
    driven_by(:selenium, using: :headless_chrome, screen_size: [ 1_280, 800 ])
  end

  it "lets a visitor explore example paths and begin a new Gift" do
    visit root_path

    expect(page).to have_css("h1", text: "Find the gift first. Then discover who it belongs with.")
    expect(page).to have_css("#gift-paths details", count: 3)
    expect(page).to have_css("#gift-paths details[open]", count: 1)
    expect(page).not_to have_link("Join")
    expect(page).not_to have_link("Claim")

    find("summary", text: /Ten quiet minutes/).click
    expect(page).to have_css("#gift-paths details[open]", minimum: 2)
    expect(page).to have_text("The gift stayed the same; the new handoff became part of its path.")

    first(:link, "Start a gift").click
    expect(page).to have_current_path(start_path)
    expect(page).to have_css("h1", text: "Choose a feeling.")
  end

  it "keeps the complete landing story inside a phone viewport" do
    page.driver.browser.execute_cdp(
      "Emulation.setDeviceMetricsOverride",
      width: 390,
      height: 844,
      deviceScaleFactor: 1,
      mobile: true
    )

    visit root_path

    expect(page).to have_css("h1", text: "Find the gift first. Then discover who it belongs with.")
    expect(page).to have_text("Somebody has to leave it for you.")
    expect(page.evaluate_script("document.documentElement.clientWidth")).to eq(390)
    expect(page.evaluate_script("document.documentElement.scrollWidth")).to be <= 390
  end

  it "keeps the example Gift subordinate to the hero claim on a tall desktop viewport" do
    page.driver.browser.execute_cdp(
      "Emulation.setDeviceMetricsOverride",
      width: 1_500,
      height: 1_578,
      deviceScaleFactor: 1,
      mobile: false
    )

    visit root_path

    hero = page.evaluate_script("document.querySelector('.landing-hero').getBoundingClientRect().toJSON()")
    gift = page.evaluate_script("document.querySelector('.landing-gift').getBoundingClientRect().toJSON()")
    hero_heading_size = page.evaluate_script("parseFloat(getComputedStyle(document.querySelector('.landing-hero h1')).fontSize)")
    gift_heading_size = page.evaluate_script("parseFloat(getComputedStyle(document.querySelector('.landing-gift h2')).fontSize)")

    expect(hero.fetch("height")).to be <= 1_000
    expect(gift.fetch("width")).to be <= 580
    expect(gift.fetch("height")).to be <= 730
    expect(hero_heading_size.to_f / gift_heading_size).to be >= 1.45
    expect(page.evaluate_script("document.documentElement.scrollWidth")).to be <= 1_500
  end
end
