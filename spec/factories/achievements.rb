FactoryBot.define do
  factory :achievement do
    association :work_experience
    content { '成果の説明' }
    display_order { 1 }
  end
end
