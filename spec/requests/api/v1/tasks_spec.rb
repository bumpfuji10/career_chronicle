require 'rails_helper'

RSpec.describe "Api::V1::Tasks", type: :request do
  let(:user) { create(:registered_user) }
  let(:resume) { create(:resume, user: user) }
  let(:company) { create(:company, resume: resume) }
  let(:position) { create(:position, company: company) }

  describe "POST /api/v1/tasks" do
    context '有効なパラメータの場合' do
      let(:valid_params) do
        {
          task: {
            position_id: position.id,
            content: 'システム開発を担当しました'
          }
        }
      end

      it 'タスク情報が作成される' do
        expect {
          post '/api/v1/tasks', params: valid_params
        }.to change(Task, :count).by(1)
      end

      it 'ステータス201が返る' do
        post '/api/v1/tasks', params: valid_params
        expect(response).to have_http_status(:created)
      end

      it '作成されたタスク情報がJSONで返る' do
        post '/api/v1/tasks', params: valid_params
        json = JSON.parse(response.body)

        expect(json['content']).to eq('システム開発を担当しました')
        expect(json['position_id']).to eq(position.id)
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) do
        {
          task: {
            position_id: position.id,
            content: ''
          }
        }
      end

      it 'タスク情報が作成されない' do
        expect {
          post '/api/v1/tasks', params: invalid_params
        }.not_to change(Task, :count)
      end

      it 'ステータス422が返る' do
        post '/api/v1/tasks', params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'エラーメッセージがJSONで返る' do
        post '/api/v1/tasks', params: invalid_params
        json = JSON.parse(response.body)

        expect(json['errors']).to be_present
        expect(json['errors']).to include("を入力してください")
      end
    end
  end

  describe "PATCH /api/v1/tasks/:id" do
    let!(:task) { create(:task, position: position) }

    context '有効なパラメータの場合' do
      let(:valid_update_params) do
        {
          task: {
            content: '更新されたタスク内容'
          }
        }
      end

      it 'タスク情報が更新される' do
        patch "/api/v1/tasks/#{task.id}", params: valid_update_params
        task.reload

        expect(task.content).to eq('更新されたタスク内容')
      end

      it 'ステータス204が返る' do
        patch "/api/v1/tasks/#{task.id}", params: valid_update_params
        expect(response).to have_http_status(:no_content)
      end

      it 'レスポンスボディが空' do
        patch "/api/v1/tasks/#{task.id}", params: valid_update_params
        expect(response.body).to be_empty
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_update_params) do
        {
          task: {
            content: ''
          }
        }
      end

      it 'タスク情報が更新されない' do
        original_content = task.content
        patch "/api/v1/tasks/#{task.id}", params: invalid_update_params
        task.reload

        expect(task.content).to eq(original_content)
      end

      it 'ステータス422が返る' do
        patch "/api/v1/tasks/#{task.id}", params: invalid_update_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'エラーメッセージがJSONで返る' do
        patch "/api/v1/tasks/#{task.id}", params: invalid_update_params
        json = JSON.parse(response.body)

        expect(json['errors']).to be_present
        expect(json['errors']).to include("を入力してください")
      end
    end
  end
end
