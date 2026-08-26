FactoryBot.define do
  factory :gift do
    gift_template
    sequence(:public_slug) { |number| "gift_slug_#{number.to_s.rjust(8, "0")}" }
    state { "discovered" }
    sequence(:render_seed)
    sequence(:creator_manage_token_digest) { |number| CapabilityToken.digest("creator capability #{number}") }
    holder_generation { 0 }
    discovered_at { Time.current }
  end
end
