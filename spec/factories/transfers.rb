FactoryBot.define do
  factory :transfer do
    gift
    sequence(:claim_token_digest) { |number| CapabilityToken.digest("claim capability #{number}") }
    state { "pending" }
    sender_display_name { "Dimitar" }
    intended_recipient_name { "Anna" }
    private_note { "I saw this and immediately thought of tomorrow. You’ve got this." }
    source_holder_generation { gift.holder_generation }
  end
end
