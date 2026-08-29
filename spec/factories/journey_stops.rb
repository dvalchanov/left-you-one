FactoryBot.define do
  factory :journey_stop do
    gift
    transfer { association(:transfer, gift:, state: "claimed") }
    add_attribute(:sequence) { 1 }
    anonymous { true }
    arrived_at { Time.current }
  end
end
