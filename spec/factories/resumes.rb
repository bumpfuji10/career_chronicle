FactoryBot.define do
  factory :resume do
    association :user
    company { '株式会社テスト' }
    position { '開発者' }
    tasks { 'システムの開発を担当しました' }
    improvements { 'プロセスを改善しました' }
    achievements { '目標を達成しました' }
  end
end