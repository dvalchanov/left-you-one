require "rails_helper"

RSpec.describe CapabilityToken do
  it "issues a high-entropy raw token and deterministic digest" do
    issued = described_class.issue

    expect(issued.raw.length).to be >= 43
    expect(issued.digest).to eq(described_class.digest(issued.raw))
    expect(issued.digest).to match(/\A[0-9a-f]{64}\z/)
  end

  it "securely validates only the matching raw token" do
    issued = described_class.issue

    expect(described_class.matches?(issued.raw, issued.digest)).to be(true)
    expect(described_class.matches?("wrong", issued.digest)).to be(false)
    expect(described_class.matches?(nil, issued.digest)).to be(false)
  end
end
