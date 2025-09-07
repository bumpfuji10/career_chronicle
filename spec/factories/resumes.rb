FactoryBot.define do
  factory :resume do
    association :user
    company { '株式会社テスト' }
    position { '開発者' }
    tasks { 'システムの開発を担当しました' }
    improvements { 'プロセスを改善しました' }
    achievements { '目標を達成しました' }
    start_at { Date.new(2020, 05, 01) }
    end_at { Date.new(2025, 04, 30) }
    summary { "テスト株式会社で開発者としてシステムの開発を担当し、プロセスを改善しました。" }
  end
end