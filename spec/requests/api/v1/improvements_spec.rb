require 'rails_helper'

RSpec.describe 'Api::V1::Improvements', type: :request do
  let(:user) { create(:registered_user) }
  let(:career_profile) { create(:career_profile, user: user) }
  let(:work_experience) { create(:work_experience, career_profile: career_profile) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_member).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:current_guest).and_return(nil)
  end

  describe 'POST /api/v1/.../improvements' do
    it '改善点を作成する' do
      expect do
        post api_v1_career_profile_work_experience_improvements_path(career_profile, work_experience),
             params: { improvement: { content: 'コードレビューを徹底', display_order: 1 } }, as: :json
      end.to change { Improvement.count }.by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['improvement']['content']).to eq('コードレビューを徹底')
    end
  end

  describe 'PATCH /api/v1/.../improvements/:id' do
    let!(:improvement) { create(:improvement, work_experience: work_experience, content: '既存改善') }

    it '改善点を更新する' do
      patch api_v1_career_profile_work_experience_improvement_path(career_profile, work_experience, improvement),
            params: { improvement: { content: '改善を更新' } }, as: :json

      expect(response).to have_http_status(:ok)
      expect(improvement.reload.content).to eq('改善を更新')
    end
  end

  describe 'DELETE /api/v1/.../improvements/:id' do
    let!(:improvement) { create(:improvement, work_experience: work_experience) }

    it '改善点を削除する' do
      expect do
        delete api_v1_career_profile_work_experience_improvement_path(career_profile, work_experience, improvement), as: :json
      end.to change { Improvement.count }.by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
