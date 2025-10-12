FactoryBot.define do
  factory :company do
    association :resume
    sequence(:name) { |n| "テスト企業#{n}" }
    industry { 'IT' }
    started_at { Date.new(2020, 4, 1) }
    ended_at { Date.new(2023, 3, 31) }

    trait :current_company do
      ended_at { nil }
    end
  end
end
