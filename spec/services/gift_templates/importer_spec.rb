require "rails_helper"

RSpec.describe GiftTemplates::Importer do
  it "imports the editable library idempotently by source key" do
    first_import = described_class.call
    original_count = GiftTemplate.count
    first_import.first.update!(main_text: "A temporary local edit.")

    second_import = described_class.call

    expect(original_count).to eq(21)
    expect(GiftTemplate.count).to eq(original_count)
    expect(second_import.first.reload.main_text).not_to eq("A temporary local edit.")
  end

  it "includes at least three active examples for every working theme" do
    described_class.call

    GiftTemplate::THEMES.each do |theme|
      expect(GiftTemplate.where(theme:, active: true).count).to be >= 3
    end
  end
end
