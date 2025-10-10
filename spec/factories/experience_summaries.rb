FactoryBot.define do
  factory :experience_summary do
    association :work_experience
    content { '私はテックカンパニーでソフトウェアエンジニアとして、業務内容の説明。その中で改善の説明。結果として成果の説明。' }
  end
end
