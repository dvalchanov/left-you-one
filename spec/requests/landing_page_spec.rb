require "rails_helper"

RSpec.describe "Landing page", type: :request do
  it "explains the product and offers only a new-Gift path" do
    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include(
      "Find the gift first. Then discover who it belongs with.",
      "It works backwards.",
      "The same gift can gather a history.",
      "Somebody has to leave it for you."
    )

    document = Nokogiri::HTML(response.body)
    expect(document.at_css("a[href='#{start_path}']")).to be_present
    expect(document.css("#gift-paths details").count).to eq(3)
    expect(document.css("#gift-paths a, #gift-paths form, #gift-paths button")).to be_empty
    expect(document.css("a").map { |link| link["href"] }).not_to include(a_string_starting_with("/open/"), a_string_starting_with("/o/"))
  end

  it "does not turn real private Gift data into a public feed" do
    gift = create(
      :gift,
      state: "held",
      holder_generation: 1,
      origin_name: "Private Sender Marker",
      current_holder_token_digest: CapabilityToken.digest("private holder marker")
    )
    transfer = create(
      :transfer,
      gift:,
      state: "claimed",
      sender_display_name: "Private Sender Marker",
      intended_recipient_name: "Private Recipient Marker",
      private_note: "Private note marker",
      claimed_at: Time.current
    )
    create(:journey_stop, gift:, transfer:, display_name: "Private Recipient Marker")

    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).not_to include(
      "Private Sender Marker",
      "Private Recipient Marker",
      "Private note marker",
      gift.public_slug
    )
  end
end
