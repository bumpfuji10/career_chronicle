FactoryBot.define do
  factory :task do
    association :position
    sequence(:task_description) { |n| "タスク内容#{n}" }
    sequence(:improvement) { |n| "工夫したこと#{n}" }
  end
end
