require 'rails_helper'

RSpec.describe 'Api::V1::Tasks', type: :request do
  let(:user) { create(:registered_user) }
  let(:career_profile) { create(:career_profile, user: user) }
  let(:work_experience) { create(:work_experience, career_profile: career_profile) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_member).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:current_guest).and_return(nil)
  end

  describe 'POST /api/v1/.../tasks' do
    it 'タスクを作成する' do
      expect do
        post api_v1_career_profile_work_experience_tasks_path(career_profile, work_experience),
             params: { task: { content: '詳細設計を担当', display_order: 1 } }, as: :json
      end.to change { Task.count }.by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['task']['content']).to eq('詳細設計を担当')
    end

    it '無効なデータの場合はエラーを返す' do
      post api_v1_career_profile_work_experience_tasks_path(career_profile, work_experience),
           params: { task: { content: '' } }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include("Content can't be blank")
    end
  end

  describe 'PATCH /api/v1/.../tasks/:id' do
    let!(:task) { create(:task, work_experience: work_experience, content: '既存タスク') }

    it 'タスクを更新する' do
      patch api_v1_career_profile_work_experience_task_path(career_profile, work_experience, task),
            params: { task: { content: '更新済みタスク' } }, as: :json

      expect(response).to have_http_status(:ok)
      expect(task.reload.content).to eq('更新済みタスク')
    end
  end

  describe 'DELETE /api/v1/.../tasks/:id' do
    let!(:task) { create(:task, work_experience: work_experience) }

    it 'タスクを削除する' do
      expect do
        delete api_v1_career_profile_work_experience_task_path(career_profile, work_experience, task), as: :json
      end.to change { Task.count }.by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
