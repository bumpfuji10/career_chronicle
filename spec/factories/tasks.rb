FactoryBot.define do
  factory :task do
    association :work_experience
    content { '業務内容の説明' }
    display_order { 1 }
  end
end
