FactoryBot.define do
  factory :task do
    association :position
    sequence(:content) { |n| "タスク内容#{n}" }
  end
end
