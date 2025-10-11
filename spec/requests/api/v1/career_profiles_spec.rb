require 'rails_helper'

RSpec.describe 'Api::V1::CareerProfiles', type: :request do
  describe 'POST /api/v1/career_profiles' do
    let(:user) { create(:registered_user) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_member).and_return(user)
      allow_any_instance_of(ApplicationController).to receive(:current_guest).and_return(nil)
    end

    it 'キャリアプロフィールを作成する' do
      post api_v1_career_profiles_path, params: { career_profile: { title: '新しいキャリア' } }, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['success']).to be true
      expect(json['career_profile']['title']).to eq('新しいキャリア')
      expect(json['career_profile']['id']).to be_present
    end
  end

  describe 'GET /api/v1/career_profiles/:id' do
    let(:user) { create(:registered_user) }
    let(:career_profile) { create(:career_profile, user: user) }
    let!(:work_experience) do
      create(:work_experience, career_profile: career_profile).tap do |experience|
        create(:task, work_experience: experience, content: 'APIの設計と実装')
        create(:improvement, work_experience: experience, content: 'CI/CDパイプラインの導入')
        create(:achievement, work_experience: experience, content: 'リリースサイクルを50%短縮')
      end
    end

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_member).and_return(user)
      allow_any_instance_of(ApplicationController).to receive(:current_guest).and_return(nil)
    end

    it 'キャリアプロフィールの詳細を返す' do
      get api_v1_career_profile_path(career_profile), as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['success']).to be true
      expect(json['career_profile']['id']).to eq(career_profile.id)
      expect(json['career_profile']['work_experiences']).not_to be_empty
      expect(json['career_profile']['work_experiences'].first['tasks'].first['content']).to eq('APIの設計と実装')
    end
  end

  describe 'ゲストユーザーの作成制限' do
    let(:guest) { create(:guest_user) }

    before do
      create(:career_profile, user: guest)
      allow_any_instance_of(ApplicationController).to receive(:current_member).and_return(nil)
      allow_any_instance_of(ApplicationController).to receive(:current_guest).and_return(guest)
    end

    it '2件目のキャリアプロフィールを作成できない' do
      post api_v1_career_profiles_path, params: { career_profile: { title: '追加キャリア' } }, as: :json

      expect(response).to have_http_status(:forbidden)
      json = JSON.parse(response.body)
      expect(json['success']).to be false
      expect(json['errors']).to include('ゲストユーザーはキャリアプロフィールを1件までしか作成できません')
    end
  end

  describe '認証されていない場合' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_member).and_return(nil)
      allow_any_instance_of(ApplicationController).to receive(:current_guest).and_return(nil)
    end

    it '401を返す' do
      post api_v1_career_profiles_path, params: { career_profile: { title: '未認証' } }, as: :json

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body)
      expect(json['success']).to be false
      expect(json['errors']).to include('認証が必要です')
    end
  end
end
