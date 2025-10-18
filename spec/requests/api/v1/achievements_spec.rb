require 'rails_helper'

RSpec.describe "Api::V1::Achievements", type: :request do
  let(:user) { create(:registered_user) }
  let(:resume) { create(:resume, user: user) }
  let(:company) { create(:company, resume: resume) }
  let(:position) { create(:position, company: company) }
  let(:task) { create(:task, position: position) }

  describe "POST /api/v1/achievements" do
    context '有効なパラメータの場合' do
      let(:valid_params) do
        {
          achievement: {
            task_id: task.id,
            content: 'プロジェクトを成功させました'
          }
        }
      end

      it '成果情報が作成される' do
        expect {
          post '/api/v1/achievements', params: valid_params
        }.to change(Achievement, :count).by(1)
      end

      it 'ステータス201が返る' do
        post '/api/v1/achievements', params: valid_params
        expect(response).to have_http_status(:created)
      end

      it '作成された成果情報がJSONで返る' do
        post '/api/v1/achievements', params: valid_params
        json = JSON.parse(response.body)

        expect(json['content']).to eq('プロジェクトを成功させました')
        expect(json['task_id']).to eq(task.id)
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) do
        {
          achievement: {
            task_id: task.id,
            content: ''
          }
        }
      end

      it '成果情報が作成されない' do
        expect {
          post '/api/v1/achievements', params: invalid_params
        }.not_to change(Achievement, :count)
      end

      it 'ステータス422が返る' do
        post '/api/v1/achievements', params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'エラーメッセージがJSONで返る' do
        post '/api/v1/achievements', params: invalid_params
        json = JSON.parse(response.body)

        expect(json['errors']).to be_present
        expect(json['errors']).to include("を入力してください")
      end
    end
  end

  describe "PATCH /api/v1/achievements/:id" do
    let!(:achievement) { create(:achievement, task: task) }

    context '有効なパラメータの場合' do
      let(:valid_update_params) do
        {
          achievement: {
            content: '更新された成果内容'
          }
        }
      end

      it '成果情報が更新される' do
        patch "/api/v1/achievements/#{achievement.id}", params: valid_update_params
        achievement.reload

        expect(achievement.content).to eq('更新された成果内容')
      end

      it 'ステータス204が返る' do
        patch "/api/v1/achievements/#{achievement.id}", params: valid_update_params
        expect(response).to have_http_status(:no_content)
      end

      it 'レスポンスボディが空' do
        patch "/api/v1/achievements/#{achievement.id}", params: valid_update_params
        expect(response.body).to be_empty
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_update_params) do
        {
          achievement: {
            content: ''
          }
        }
      end

      it '成果情報が更新されない' do
        original_content = achievement.content
        patch "/api/v1/achievements/#{achievement.id}", params: invalid_update_params
        achievement.reload

        expect(achievement.content).to eq(original_content)
      end

      it 'ステータス422が返る' do
        patch "/api/v1/achievements/#{achievement.id}", params: invalid_update_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'エラーメッセージがJSONで返る' do
        patch "/api/v1/achievements/#{achievement.id}", params: invalid_update_params
        json = JSON.parse(response.body)

        expect(json['errors']).to be_present
        expect(json['errors']).to include("を入力してください")
      end
    end
  end
end
