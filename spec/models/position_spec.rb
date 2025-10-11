require 'rails_helper'

RSpec.describe Position, type: :model do
  describe 'アソシエーション' do
    it '企業に属する' do
      association = described_class.reflect_on_association(:company)
      expect(association.macro).to eq(:belongs_to)
    end

    it '複数のタスクを持つ' do
      association = described_class.reflect_on_association(:tasks)
      expect(association.macro).to eq(:has_many)
    end

    it '役職が削除されると、関連するタスクも削除される' do
      association = described_class.reflect_on_association(:tasks)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'バリデーション' do
    let(:user) { Member.create!(name: 'テストユーザー', email: 'test@example.com', password: 'password123') }
    let(:resume) { Resume.create!(user: user) }
    let(:company) { Company.create!(resume: resume, name: 'テスト企業', industry: 'IT', started_at: Date.today, description: '説明') }

    context '必須項目の確認' do
      it 'titleが必須である' do
        position = Position.new(company: company, title: nil, started_at: Date.today)
        expect(position).to be_invalid
        expect(position.errors[:title]).to include("を入力してください")
      end

      it 'started_atが必須である' do
        position = Position.new(company: company, title: 'エンジニア', started_at: nil)
        expect(position).to be_invalid
        expect(position.errors[:started_at]).to include("を入力してください")
      end

      it 'companyが紐づいていない場合、作成に失敗する' do
        position = Position.new(company: nil, title: 'エンジニア', started_at: Date.today)
        expect(position).to be_invalid
        expect(position.errors[:company]).to be_present
      end
    end

    context 'ended_atの扱い' do
      it 'ended_atがnilでも有効（現在この役職）' do
        position = Position.new(company: company, title: 'エンジニア', started_at: Date.today, ended_at: nil)
        expect(position).to be_valid
      end

      it 'ended_atが設定されていても有効（過去の役職）' do
        position = Position.new(company: company, title: 'エンジニア', started_at: Date.new(2020, 1, 1), ended_at: Date.new(2023, 12, 31))
        expect(position).to be_valid
      end
    end
  end

  describe '作成' do
    let(:user) { Member.create!(name: 'テストユーザー', email: 'test@example.com', password: 'password123') }
    let(:resume) { Resume.create!(user: user) }
    let(:company) { Company.create!(resume: resume, name: 'テスト企業', industry: 'IT', started_at: Date.today, description: '説明') }

    it '役職情報が正常に作成できる' do
      position = Position.create!(
        company: company,
        title: 'シニアエンジニア',
        started_at: Date.new(2020, 4, 1),
        ended_at: Date.new(2023, 3, 31)
      )

      expect(position).to be_persisted
      expect(position.company).to eq(company)
      expect(position.title).to eq('シニアエンジニア')
      expect(position.tasks).to be_empty
    end

    it '現在の役職情報が作成できる（ended_atなし）' do
      position = Position.create!(
        company: company,
        title: 'テックリード',
        started_at: Date.new(2023, 4, 1),
        ended_at: nil
      )

      expect(position).to be_persisted
      expect(position.ended_at).to be_nil
    end
  end
end
