FactoryBot.define do
  factory :achievement do
    association :task
    sequence(:content) { |n| "成果内容#{n}" }
  end
end
