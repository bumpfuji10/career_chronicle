require 'rails_helper'

RSpec.describe 'Api::V1::Achievements', type: :request do
  let(:user) { create(:registered_user) }
  let(:career_profile) { create(:career_profile, user: user) }
  let(:work_experience) { create(:work_experience, career_profile: career_profile) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_member).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:current_guest).and_return(nil)
  end

  describe 'POST /api/v1/.../achievements' do
    it '成果を作成する' do
      expect do
        post api_v1_career_profile_work_experience_achievements_path(career_profile, work_experience),
             params: { achievement: { content: '売上を20%増加', display_order: 1 } }, as: :json
      end.to change { Achievement.count }.by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['achievement']['content']).to eq('売上を20%増加')
    end
  end

  describe 'PATCH /api/v1/.../achievements/:id' do
    let!(:achievement) { create(:achievement, work_experience: work_experience, content: '既存成果') }

    it '成果を更新する' do
      patch api_v1_career_profile_work_experience_achievement_path(career_profile, work_experience, achievement),
            params: { achievement: { content: '成果を更新' } }, as: :json

      expect(response).to have_http_status(:ok)
      expect(achievement.reload.content).to eq('成果を更新')
    end
  end

  describe 'DELETE /api/v1/.../achievements/:id' do
    let!(:achievement) { create(:achievement, work_experience: work_experience) }

    it '成果を削除する' do
      expect do
        delete api_v1_career_profile_work_experience_achievement_path(career_profile, work_experience, achievement), as: :json
      end.to change { Achievement.count }.by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
