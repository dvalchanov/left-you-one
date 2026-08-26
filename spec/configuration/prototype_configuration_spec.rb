require "rails_helper"

RSpec.describe LeftYouOne::Configuration do
  it "defaults prototype mode on in development" do
    config = described_class.new(env: {}, rails_env: ActiveSupport::EnvironmentInquirer.new("development"))

    expect(config.prototype_mode).to be(true)
    expect(config.display_price_cents).to eq(200)
    expect(config.display_currency).to eq("USD")
  end

  it "reads explicit environment values through the central interface" do
    config = described_class.new(
      env: {
        "PROTOTYPE_MODE" => "false",
        "DISPLAY_PRICE_CENTS" => "350",
        "DISPLAY_CURRENCY" => "eur"
      },
      rails_env: ActiveSupport::EnvironmentInquirer.new("development")
    )

    expect(config.prototype_mode).to be(false)
    expect(config.display_price_cents).to eq(350)
    expect(config.display_currency).to eq("EUR")
  end
end
