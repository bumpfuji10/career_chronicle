FactoryBot.define do
  factory :position do
    association :company
    sequence(:title) { |n| "役職#{n}" }
    started_at { Date.new(2020, 4, 1) }
    ended_at { Date.new(2023, 3, 31) }

    trait :current_position do
      ended_at { nil }
    end
  end
end
