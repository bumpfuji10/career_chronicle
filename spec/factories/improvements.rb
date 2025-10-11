FactoryBot.define do
  factory :improvement do
    association :work_experience
    content { '改善の説明' }
    display_order { 1 }
  end
end
