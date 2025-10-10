FactoryBot.define do
  factory :work_experience do
    association :career_profile
    company { 'テックカンパニー' }
    position { 'ソフトウェアエンジニア' }
    start_at { Date.new(2020, 1, 1) }
    end_at { Date.new(2021, 12, 31) }
    is_current { false }
    display_order { 1 }
  end
end
