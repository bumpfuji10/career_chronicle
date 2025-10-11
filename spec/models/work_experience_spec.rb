require 'rails_helper'

RSpec.describe WorkExperience, type: :model do
  describe 'バリデーション' do
    it '会社名、役職、開始日のいずれかがなければ無効になる' do
      work_experience = described_class.new
      expect(work_experience).not_to be_valid
      expect(work_experience.errors[:company]).to include("can't be blank")
      expect(work_experience.errors[:position]).to include("can't be blank")
      expect(work_experience.errors[:start_at]).to include("can't be blank")
    end

    it '必要な属性があれば有効になる' do
      work_experience = build(:work_experience)
      expect(work_experience).to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'キャリアプロフィールに属する' do
      association = described_class.reflect_on_association(:career_profile)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'タスク、改善、成果を多数持つ' do
      expect(described_class.reflect_on_association(:tasks).macro).to eq(:has_many)
      expect(described_class.reflect_on_association(:improvements).macro).to eq(:has_many)
      expect(described_class.reflect_on_association(:achievements).macro).to eq(:has_many)
      expect(described_class.reflect_on_association(:experience_summary).macro).to eq(:has_one)
    end
  end

  describe '#generate_summary' do
    it '関連データからサマリーを生成する' do
      work_experience = create(:work_experience)
      create(:task, work_experience: work_experience, content: '新規機能の設計と実装を担当')
      create(:improvement, work_experience: work_experience, content: 'コードレビュー体制を構築')
      create(:achievement, work_experience: work_experience, content: 'リリース後の障害件数を50%削減')

      summary = work_experience.generate_summary

      expect(summary).to eq('私はテックカンパニーでソフトウェアエンジニアとして、新規機能の設計と実装を担当。その中でコードレビュー体制を構築。結果としてリリース後の障害件数を50%削減。')
    end

    it '関連データが存在しない場合でもデフォルト文言で生成する' do
      work_experience = create(:work_experience)

      summary = work_experience.generate_summary

      expect(summary).to eq('私はテックカンパニーでソフトウェアエンジニアとして、業務を担当。その中で工夫を行い。結果として成果を上げました。')
    end
  end
end
