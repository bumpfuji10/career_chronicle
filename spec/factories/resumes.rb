FactoryBot.define do
  factory :resume do
    association :user
    summary { nil }

    trait :with_summary do
      summary { '私は株式会社ABCで営業として働きました。その中で顧客との関係構築に注力し、売上目標を達成しました。' }
    end
  end
end