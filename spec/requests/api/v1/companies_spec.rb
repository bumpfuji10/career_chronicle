require 'rails_helper'

RSpec.describe "Api::V1::Companies", type: :request do
  let(:user) { create(:registered_user) }
  let(:resume) { create(:resume, user: user) }

  describe "POST /api/v1/companies" do
    context '有効なパラメータの場合' do
      let(:valid_params) do
        {
          company: {
            resume_id: resume.id,
            name: 'テック株式会社',
            industry: 'IT',
            started_at: '2020-04-01',
            ended_at: '2023-03-31'
          }
        }
      end

      it '企業情報が作成される' do
        expect {
          post '/api/v1/companies', params: valid_params
        }.to change(Company, :count).by(1)
      end

      it 'ステータス201が返る' do
        post '/api/v1/companies', params: valid_params
        expect(response).to have_http_status(:created)
      end

      it '作成された企業情報がJSONで返る' do
        post '/api/v1/companies', params: valid_params
        json = JSON.parse(response.body)

        expect(json['name']).to eq('テック株式会社')
        expect(json['industry']).to eq('IT')
        expect(json['resume_id']).to eq(resume.id)
      end
    end

    context '現在在籍中の企業（ended_atがnil）' do
      let(:current_job_params) do
        {
          company: {
            resume_id: resume.id,
            name: '現在の企業',
            industry: 'IT',
            started_at: '2023-04-01',
            ended_at: nil
          }
        }
      end

      it '企業情報が作成される' do
        expect {
          post '/api/v1/companies', params: current_job_params
        }.to change(Company, :count).by(1)
      end

      it 'ended_atがnilで保存される' do
        post '/api/v1/companies', params: current_job_params
        json = JSON.parse(response.body)

        expect(json['ended_at']).to be_nil
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) do
        {
          company: {
            resume_id: resume.id,
            name: '',
            industry: 'IT',
            started_at: '2020-04-01'
          }
        }
      end

      it '企業情報が作成されない' do
        expect {
          post '/api/v1/companies', params: invalid_params
        }.not_to change(Company, :count)
      end

      it 'ステータス422が返る' do
        post '/api/v1/companies', params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'エラーメッセージがJSONで返る' do
        post '/api/v1/companies', params: invalid_params
        json = JSON.parse(response.body)

        expect(json['errors']).to be_present
        expect(json['errors']).to include("を入力してください")
      end
    end
  end
end
