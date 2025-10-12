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
    let(:user) { create(:registered_user) }
    let(:resume) { create(:resume, user: user) }
    let(:company) { create(:company, resume: resume) }
    let(:position) { create(:position, company: company) }

    context '必須項目の確認' do
      it 'task_descriptionが必須である' do
        task = Task.new(position: position, task_description: nil, improvement: '工夫したこと')
        expect(task).to be_invalid
        expect(task.errors[:task_description]).to include("を入力してください")
      end

      it 'improvementが必須である' do
        task = Task.new(position: position, task_description: 'やったこと', improvement: nil)
        expect(task).to be_invalid
        expect(task.errors[:improvement]).to include("を入力してください")
      end

      it 'positionが紐づいていない場合、作成に失敗する' do
        task = Task.new(position: nil, task_description: 'Reactでの開発', improvement: 'パフォーマンス改善')
        expect(task).to be_invalid
        expect(task.errors[:position]).to be_present
      end

      it '有効な属性で作成できる' do
        task = Task.new(position: position, task_description: 'Reactでの開発', improvement: 'パフォーマンス改善')
        expect(task).to be_valid
      end
    end
  end

  describe '作成' do
    let(:user) { create(:registered_user) }
    let(:resume) { create(:resume, user: user) }
    let(:company) { create(:company, resume: resume) }
    let(:position) { create(:position, company: company) }

    it 'タスク情報が正常に作成できる' do
      task = Task.create!(
        position: position,
        task_description: 'Reactを用いたSPA開発',
        improvement: 'コンポーネントの再利用性を高めた'
      )

      expect(task).to be_persisted
      expect(task.position).to eq(position)
      expect(task.task_description).to eq('Reactを用いたSPA開発')
      expect(task.improvement).to eq('コンポーネントの再利用性を高めた')
      expect(task.achievements).to be_empty
    end
  end
end
