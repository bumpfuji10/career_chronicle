require 'rails_helper'

RSpec.describe ResumeJsonBuildService, type: :service do
  describe '#execute' do
    let(:user) { create(:registered_user) }
    let(:resume) { create(:resume, user: user) }

    context '関連データがない場合' do
      it 'resumeの基本情報のみを返す' do
        result = described_class.new(resume: resume).execute

        expect(result['id']).to eq(resume.id)
        expect(result['user_id']).to eq(user.id)
        expect(result['companies']).to eq([])
      end
    end

    context '関連データが存在する場合' do
      let!(:company) do
        create(:company,
          resume: resume,
          name: '株式会社ABC',
          industry: 'IT',
          started_at: Date.new(2020, 4, 1),
          ended_at: Date.new(2022, 3, 31)
        )
      end

      let!(:position) do
        create(:position,
          company: company,
          title: 'エンジニア',
          department: '技術部',
          started_at: Date.new(2020, 4, 1),
          ended_at: Date.new(2022, 3, 31)
        )
      end

      let!(:task) do
        create(:task,
          position: position,
          task_description: 'Webアプリケーション開発',
          improvement: 'React/Node.jsを使用'
        )
      end

      let!(:achievement) do
        create(:achievement,
          task: task,
          content: '売上目標120%達成'
        )
      end

      it '全ての関連データを含むJSONを返す' do
        result = described_class.new(resume: resume).execute

        expect(result['id']).to eq(resume.id)
        expect(result['companies'].size).to eq(1)

        company_data = result['companies'].first
        expect(company_data['name']).to eq('株式会社ABC')
        expect(company_data['industry']).to eq('IT')

        position_data = company_data['positions'].first
        expect(position_data['title']).to eq('エンジニア')
        expect(position_data['department']).to eq('技術部')

        task_data = position_data['tasks'].first
        expect(task_data['task_description']).to eq('Webアプリケーション開発')
        expect(task_data['improvement']).to eq('React/Node.jsを使用')

        achievement_data = task_data['achievements'].first
        expect(achievement_data['content']).to eq('売上目標120%達成')
      end

      it 'created_atとupdated_atを含む' do
        result = described_class.new(resume: resume).execute

        expect(result['created_at']).to be_present
        expect(result['updated_at']).to be_present

        company_data = result['companies'].first
        expect(company_data['created_at']).to be_present
        expect(company_data['updated_at']).to be_present
      end
    end

    context '複数の企業・役職・タスク・実績が存在する場合' do
      let!(:company1) { create(:company, resume: resume, name: '株式会社ABC') }
      let!(:company2) { create(:company, resume: resume, name: '株式会社XYZ') }
      let!(:position1) { create(:position, company: company1) }
      let!(:position2) { create(:position, company: company1) }
      let!(:task1) { create(:task, position: position1) }
      let!(:task2) { create(:task, position: position1) }
      let!(:achievement1) { create(:achievement, task: task1) }
      let!(:achievement2) { create(:achievement, task: task1) }

      it '全ての関連データをネストして返す' do
        result = described_class.new(resume: resume).execute

        expect(result['companies'].size).to eq(2)
        expect(result['companies'].first['positions'].size).to eq(2)
        expect(result['companies'].first['positions'].first['tasks'].size).to eq(2)
        expect(result['companies'].first['positions'].first['tasks'].first['achievements'].size).to eq(2)
      end
    end

    context 'improvementがnilの場合' do
      let!(:company) { create(:company, resume: resume) }
      let!(:position) { create(:position, company: company) }
      let!(:task) { create(:task, position: position, improvement: nil) }

      it 'improvementがnullで返される' do
        result = described_class.new(resume: resume).execute

        task_data = result['companies'].first['positions'].first['tasks'].first
        expect(task_data['improvement']).to be_nil
      end
    end
  end
end
