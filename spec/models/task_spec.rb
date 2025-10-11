require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'アソシエーション' do
    it '役職に属する' do
      association = described_class.reflect_on_association(:position)
      expect(association.macro).to eq(:belongs_to)
    end

    it '複数の実績を持つ' do
      association = described_class.reflect_on_association(:achievements)
      expect(association.macro).to eq(:has_many)
    end

    it 'タスクが削除されると、関連する実績も削除される' do
      association = described_class.reflect_on_association(:achievements)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'バリデーション' do
    let(:user) { Member.create!(name: 'テストユーザー', email: 'test@example.com', password: 'password123') }
    let(:resume) { Resume.create!(user: user) }
    let(:company) { Company.create!(resume: resume, name: 'テスト企業', industry: 'IT', started_at: Date.today, description: '説明') }
    let(:position) { Position.create!(company: company, title: 'エンジニア', started_at: Date.today) }

    context '必須項目の確認' do
      it 'contentが必須である' do
        task = Task.new(position: position, content: nil)
        expect(task).to be_invalid
        expect(task.errors[:content]).to include("を入力してください")
      end

      it 'positionが紐づいていない場合、作成に失敗する' do
        task = Task.new(position: nil, content: 'Reactでの開発')
        expect(task).to be_invalid
        expect(task.errors[:position]).to be_present
      end

      it '有効な属性で作成できる' do
        task = Task.new(position: position, content: 'Reactでの開発')
        expect(task).to be_valid
      end
    end
  end

  describe '作成' do
    let(:user) { Member.create!(name: 'テストユーザー', email: 'test@example.com', password: 'password123') }
    let(:resume) { Resume.create!(user: user) }
    let(:company) { Company.create!(resume: resume, name: 'テスト企業', industry: 'IT', started_at: Date.today, description: '説明') }
    let(:position) { Position.create!(company: company, title: 'エンジニア', started_at: Date.today) }

    it 'タスク情報が正常に作成できる' do
      task = Task.create!(
        position: position,
        content: 'Reactを用いたSPA開発'
      )

      expect(task).to be_persisted
      expect(task.position).to eq(position)
      expect(task.content).to eq('Reactを用いたSPA開発')
      expect(task.achievements).to be_empty
    end
  end
end
