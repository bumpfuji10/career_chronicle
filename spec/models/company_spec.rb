require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'アソシエーション' do
    it '経歴書に属する' do
      association = described_class.reflect_on_association(:resume)
      expect(association.macro).to eq(:belongs_to)
    end

    it '複数の役職を持つ' do
      association = described_class.reflect_on_association(:positions)
      expect(association.macro).to eq(:has_many)
    end

    it '企業が削除されると、関連する役職も削除される' do
      association = described_class.reflect_on_association(:positions)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'バリデーション' do
    let(:user) { Member.create!(name: 'テストユーザー', email: 'test@example.com', password: 'password123') }
    let(:resume) { Resume.create!(user: user) }

    context '必須項目の確認' do
      it 'nameが必須である' do
        company = Company.new(resume: resume, name: nil, industry: 'IT', started_at: Date.today, description: '説明')
        expect(company).to be_invalid
        expect(company.errors[:name]).to include("を入力してください")
      end

      it 'industryが必須である' do
        company = Company.new(resume: resume, name: 'テスト企業', industry: nil, started_at: Date.today, description: '説明')
        expect(company).to be_invalid
        expect(company.errors[:industry]).to include("を入力してください")
      end

      it 'started_atが必須である' do
        company = Company.new(resume: resume, name: 'テスト企業', industry: 'IT', started_at: nil, description: '説明')
        expect(company).to be_invalid
        expect(company.errors[:started_at]).to include("を入力してください")
      end

      it 'descriptionが必須である' do
        company = Company.new(resume: resume, name: 'テスト企業', industry: 'IT', started_at: Date.today, description: nil)
        expect(company).to be_invalid
        expect(company.errors[:description]).to include("を入力してください")
      end

      it 'resumeが紐づいていない場合、作成に失敗する' do
        company = Company.new(resume: nil, name: 'テスト企業', industry: 'IT', started_at: Date.today, description: '説明')
        expect(company).to be_invalid
        expect(company.errors[:resume]).to be_present
      end
    end

    context 'ended_atの扱い' do
      it 'ended_atがnilでも有効（現在在籍中の企業）' do
        company = Company.new(resume: resume, name: 'テスト企業', industry: 'IT', started_at: Date.today, ended_at: nil, description: '説明')
        expect(company).to be_valid
      end

      it 'ended_atが設定されていても有効（退職済みの企業）' do
        company = Company.new(resume: resume, name: 'テスト企業', industry: 'IT', started_at: Date.new(2020, 1, 1), ended_at: Date.new(2023, 12, 31), description: '説明')
        expect(company).to be_valid
      end
    end
  end

  describe '作成' do
    let(:user) { Member.create!(name: 'テストユーザー', email: 'test@example.com', password: 'password123') }
    let(:resume) { Resume.create!(user: user) }

    it '企業情報が正常に作成できる' do
      company = Company.create!(
        resume: resume,
        name: 'テック株式会社',
        industry: 'IT',
        started_at: Date.new(2020, 4, 1),
        ended_at: Date.new(2023, 3, 31),
        description: 'Webアプリケーション開発'
      )

      expect(company).to be_persisted
      expect(company.resume).to eq(resume)
      expect(company.name).to eq('テック株式会社')
      expect(company.industry).to eq('IT')
      expect(company.positions).to be_empty
    end

    it '現在在籍中の企業情報が作成できる（ended_atなし）' do
      company = Company.create!(
        resume: resume,
        name: '現在の企業',
        industry: 'IT',
        started_at: Date.new(2023, 4, 1),
        ended_at: nil,
        description: 'バックエンド開発'
      )

      expect(company).to be_persisted
      expect(company.ended_at).to be_nil
    end
  end
end
