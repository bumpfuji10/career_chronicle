FactoryBot.define do
  factory :career_profile do
    association :user, factory: :registered_user
    title { 'キャリアプロフィール' }
  end
end
