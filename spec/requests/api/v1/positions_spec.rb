require 'rails_helper'

RSpec.describe "Api::V1::Positions", type: :request do
  let(:user) { create(:registered_user) }
  let(:resume) { create(:resume, user: user) }
  let(:company) { create(:company, resume: resume) }

  describe "POST /api/v1/positions" do
    context '有効なパラメータの場合' do
      let(:valid_params) do
        {
          position: {
            company_id: company.id,
            title: 'シニアエンジニア',
            department: '開発部',
            started_at: '2020-04-01',
            ended_at: '2023-03-31'
          }
        }
      end

      it '役職情報が作成される' do
        expect {
          post '/api/v1/positions', params: valid_params
        }.to change(Position, :count).by(1)
      end

      it 'ステータス201が返る' do
        post '/api/v1/positions', params: valid_params
        expect(response).to have_http_status(:created)
      end

      it '作成された役職情報がJSONで返る' do
        post '/api/v1/positions', params: valid_params
        json = JSON.parse(response.body)

        expect(json['title']).to eq('シニアエンジニア')
        expect(json['department']).to eq('開発部')
        expect(json['company_id']).to eq(company.id)
      end
    end

    context '現在在籍中の役職（ended_atがnil）' do
      let(:current_position_params) do
        {
          position: {
            company_id: company.id,
            title: '現在の役職',
            department: '技術部',
            started_at: '2023-04-01',
            ended_at: nil
          }
        }
      end

      it '役職情報が作成される' do
        expect {
          post '/api/v1/positions', params: current_position_params
        }.to change(Position, :count).by(1)
      end

      it 'ended_atがnilで保存される' do
        post '/api/v1/positions', params: current_position_params
        json = JSON.parse(response.body)

        expect(json['ended_at']).to be_nil
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) do
        {
          position: {
            company_id: company.id,
            title: '',
            started_at: '2020-04-01'
          }
        }
      end

      it '役職情報が作成されない' do
        expect {
          post '/api/v1/positions', params: invalid_params
        }.not_to change(Position, :count)
      end

      it 'ステータス422が返る' do
        post '/api/v1/positions', params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'エラーメッセージがJSONで返る' do
        post '/api/v1/positions', params: invalid_params
        json = JSON.parse(response.body)

        expect(json['errors']).to be_present
        expect(json['errors']).to include("を入力してください")
      end
    end
  end

  describe "PATCH /api/v1/positions/:id" do
    let!(:position) { create(:position, company: company) }

    context '有効なパラメータの場合' do
      let(:valid_update_params) do
        {
          position: {
            title: '更新された役職名',
            department: '更新された部署',
            started_at: '2021-01-01',
            ended_at: '2024-12-31'
          }
        }
      end

      it '役職情報が更新される' do
        patch "/api/v1/positions/#{position.id}", params: valid_update_params
        position.reload

        expect(position.title).to eq('更新された役職名')
        expect(position.department).to eq('更新された部署')
        expect(position.started_at).to eq(Date.parse('2021-01-01'))
        expect(position.ended_at).to eq(Date.parse('2024-12-31'))
      end

      it 'ステータス204が返る' do
        patch "/api/v1/positions/#{position.id}", params: valid_update_params
        expect(response).to have_http_status(:no_content)
      end

      it 'レスポンスボディが空' do
        patch "/api/v1/positions/#{position.id}", params: valid_update_params
        expect(response.body).to be_empty
      end
    end

    context 'ended_atをnilに更新する場合' do
      let(:update_to_current_params) do
        {
          position: {
            title: position.title,
            started_at: position.started_at,
            ended_at: nil
          }
        }
      end

      it 'ended_atがnilで更新される' do
        patch "/api/v1/positions/#{position.id}", params: update_to_current_params
        position.reload

        expect(position.ended_at).to be_nil
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_update_params) do
        {
          position: {
            title: '',
            started_at: '2020-04-01'
          }
        }
      end

      it '役職情報が更新されない' do
        original_title = position.title
        patch "/api/v1/positions/#{position.id}", params: invalid_update_params
        position.reload

        expect(position.title).to eq(original_title)
      end

      it 'ステータス422が返る' do
        patch "/api/v1/positions/#{position.id}", params: invalid_update_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'エラーメッセージがJSONで返る' do
        patch "/api/v1/positions/#{position.id}", params: invalid_update_params
        json = JSON.parse(response.body)

        expect(json['errors']).to be_present
        expect(json['errors']).to include("を入力してください")
      end
    end
  end
end
