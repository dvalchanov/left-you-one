FactoryBot.define do
  factory :gift_template do
    sequence(:source_key) { |number| "quietly_specific_gift_#{number}" }
    theme { "calm" }
    main_text { "Ten quiet minutes with nothing to prove." }
    context_text { "For the day that will not stop asking things of you." }
    ritual_text { "Use them slowly." }
    visual_family { "paper" }
    finish { "soft_grain" }
    background_key { "curtain_light" }
    sequence(:design_seed)
    active { true }
  end
end
