require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe 'アソシエーション' do
    it 'タスクに属する' do
      association = described_class.reflect_on_association(:task)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'バリデーション' do
    let(:user) { Member.create!(name: 'テストユーザー', email: 'test@example.com', password: 'password123') }
    let(:resume) { Resume.create!(user: user) }
    let(:company) { Company.create!(resume: resume, name: 'テスト企業', industry: 'IT', started_at: Date.today, description: '説明') }
    let(:position) { Position.create!(company: company, title: 'エンジニア', started_at: Date.today) }
    let(:task) { Task.create!(position: position, content: 'Reactでの開発') }

    context '必須項目の確認' do
      it 'contentが必須である' do
        achievement = Achievement.new(task: task, content: nil)
        expect(achievement).to be_invalid
        expect(achievement.errors[:content]).to include("を入力してください")
      end

      it 'taskが紐づいていない場合、作成に失敗する' do
        achievement = Achievement.new(task: nil, content: 'ページ表示速度を30%改善')
        expect(achievement).to be_invalid
        expect(achievement.errors[:task]).to be_present
      end

      it '有効な属性で作成できる' do
        achievement = Achievement.new(task: task, content: 'ページ表示速度を30%改善')
        expect(achievement).to be_valid
      end
    end
  end

  describe '作成' do
    let(:user) { Member.create!(name: 'テストユーザー', email: 'test@example.com', password: 'password123') }
    let(:resume) { Resume.create!(user: user) }
    let(:company) { Company.create!(resume: resume, name: 'テスト企業', industry: 'IT', started_at: Date.today, description: '説明') }
    let(:position) { Position.create!(company: company, title: 'エンジニア', started_at: Date.today) }
    let(:task) { Task.create!(position: position, content: 'Reactでの開発') }

    it '実績情報が正常に作成できる' do
      achievement = Achievement.create!(
        task: task,
        content: 'ページ表示速度を30%改善し、ユーザー満足度が向上'
      )

      expect(achievement).to be_persisted
      expect(achievement.task).to eq(task)
      expect(achievement.content).to eq('ページ表示速度を30%改善し、ユーザー満足度が向上')
    end
  end
end
