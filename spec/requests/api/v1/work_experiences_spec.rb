require 'rails_helper'

RSpec.describe 'Api::V1::WorkExperiences', type: :request do
  let(:user) { create(:registered_user) }
  let(:career_profile) { create(:career_profile, user: user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_member).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:current_guest).and_return(nil)
  end

  describe 'POST /api/v1/career_profiles/:career_profile_id/work_experiences' do
    it '職務経歴を作成する' do
      params = {
        work_experience: {
          company: 'テック企業',
          position: 'バックエンドエンジニア',
          start_at: '2022-01-01',
          end_at: '2023-01-01',
          is_current: false
        }
      }

      expect {
        post api_v1_career_profile_work_experiences_path(career_profile), params: params, as: :json
      }.to change { WorkExperience.count }.by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['work_experience']['company']).to eq('テック企業')
    end

    it '無効なデータの場合はエラーを返す' do
      post api_v1_career_profile_work_experiences_path(career_profile), params: { work_experience: { company: '' } }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['success']).to be false
      expect(json['errors']).to include("Company can't be blank")
    end
  end

  describe 'GET /api/v1/career_profiles/:career_profile_id/work_experiences/:id' do
    let!(:work_experience) { create(:work_experience, career_profile: career_profile) }

    it '職務経歴を取得する' do
      get api_v1_career_profile_work_experience_path(career_profile, work_experience), as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['work_experience']['id']).to eq(work_experience.id)
    end
  end

  describe 'PATCH /api/v1/career_profiles/:career_profile_id/work_experiences/:id' do
    let!(:work_experience) { create(:work_experience, career_profile: career_profile, company: '旧社名') }

    it '職務経歴を更新する' do
      patch api_v1_career_profile_work_experience_path(career_profile, work_experience),
            params: { work_experience: { company: '新社名' } }, as: :json

      expect(response).to have_http_status(:ok)
      expect(work_experience.reload.company).to eq('新社名')
    end
  end

  describe 'POST /generate_summary' do
    let!(:work_experience) { create(:work_experience, career_profile: career_profile) }

    before do
      create(:task, work_experience: work_experience, content: 'REST APIの設計')
      create(:improvement, work_experience: work_experience, content: '自動テストの導入')
      create(:achievement, work_experience: work_experience, content: '品質指標を向上')
    end

    it 'サマリーを生成して保存する' do
      post generate_summary_api_v1_career_profile_work_experience_path(career_profile, work_experience), as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['summary']).to include('REST APIの設計')
      expect(work_experience.reload.experience_summary.content).to eq(json['summary'])
    end
  end

  describe '認証されていない場合' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_member).and_return(nil)
      allow_any_instance_of(ApplicationController).to receive(:current_guest).and_return(nil)
    end

    it '401を返す' do
      post api_v1_career_profile_work_experiences_path(career_profile), params: { work_experience: { company: 'NG' } }, as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
