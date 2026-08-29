require "rails_helper"
require "tmpdir"

RSpec.describe GiftVisuals::PrototypeDefault do
  it "loads, sanitizes, and snapshots the selected Paper World treatment" do
    template = build(:gift_template, visual_family: "luminous", background_key: "afterglow_meadow")

    snapshot = described_class.snapshot_for(template)

    expect(snapshot).to include(
      "visual_family" => "paper_world",
      "background" => "paper_world",
      "finish" => "warm_grain",
      "composition" => "bottom_left",
      "sealed_treatment" => "closed_frame",
      "motion" => "slow_push",
      "grain" => "soft",
      "overlay" => "paper_edge",
      "text_tone" => "dark"
    )
  end

  it "persists only allowlisted values" do
    Dir.mktmpdir do |directory|
      path = Pathname(directory).join("default.yml")
      result = described_class.save!(
        {
          visual_family: "paper_world",
          background: "https://example.com/tracker.jpg",
          motion: "spin",
          text_tone: "dark"
        },
        path:
      )

      expect(result).to include(
        "visual_family" => "paper_world",
        "background" => "paper_world",
        "motion" => "slow_push",
        "text_tone" => "dark"
      )
      expect(path.read).not_to include("example.com", "spin")
    end
  end
end
