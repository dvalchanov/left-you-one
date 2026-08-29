require "rails_helper"
require "tmpdir"

RSpec.describe "Prototype visual defaults", type: :request do
  it "saves an allowlisted lab treatment only in development and test" do
    Dir.mktmpdir do |directory|
      path = Pathname(directory).join("prototype.yml")
      allow(GiftVisuals::PrototypeDefault).to receive(:default_path).and_return(path)

      post dev_prototype_visual_default_path, params: {
        visual_family: "paper_world",
        background: "paper_world",
        finish: "warm_grain",
        composition: "bottom_left",
        sealed_treatment: "closed_frame",
        motion: "slow_push",
        grain: "soft",
        overlay: "paper_edge",
        text_tone: "dark",
        asset: "https://example.com/tracker.jpg"
      }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to include(
        "visual_family" => "paper_world",
        "background" => "paper_world",
        "sealed_treatment" => "closed_frame"
      )
      expect(path.read).not_to include("example.com")
    end
  end

  it "applies a changed default only to Gifts discovered afterward" do
    create(
      :gift_template,
      theme: "calm",
      source_key: "visual_default_integration",
      visual_family: "luminous",
      background_key: "afterglow_meadow"
    )

    Dir.mktmpdir do |directory|
      path = Pathname(directory).join("prototype.yml")
      allow(GiftVisuals::PrototypeDefault).to receive(:default_path).and_return(path)

      save_default(visual_family: "paper_world", background: "paper_world", text_tone: "dark")
      first = discover_calm_gift
      expect(response.body).to include("Paper World · A way through")

      save_default(visual_family: "quiet_light", background: "quiet_light", text_tone: "dark")
      second = discover_calm_gift
      expect(response.body).to include("Quiet Light · Linen at four")

      expect(first.reload.visual_configuration).to include(
        "visual_family" => "paper_world",
        "background" => "paper_world"
      )
      expect(second.visual_configuration).to include(
        "visual_family" => "quiet_light",
        "background" => "quiet_light"
      )
    end
  end

  private

  def save_default(attributes)
    post dev_prototype_visual_default_path, params: attributes
    expect(response).to have_http_status(:ok)
  end

  def discover_calm_gift
    get start_path
    creation_key = Nokogiri::HTML(response.body).at_css("input[name='creation_key']")["value"]
    post gifts_path, params: { creation_key:, theme: "calm" }
    follow_redirect!
    follow_redirect!
    Gift.order(:created_at).last
  end
end
