require 'rails_helper'

RSpec.describe "Api::V1::Resumes", type: :request do
  let(:user) { create(:registered_user) }

  describe "GET /api/v1/resumes/:resume_id" do
    let(:user) { FactoryBot.create(:registered_user) }
    let!(:resume) { FactoryBot.create(:resume, :with_summary, user: user) }
    
    it "アクセスが可能であること" do
      get("/api/v1/resumes/#{resume.id}")
      expect(response.status).to eq 200
    end

    context "他人の経歴書の場合" do
      let(:other_user_resume) do
        other_user = FactoryBot.create(:registered_user)
        resume = FactoryBot.create(:resume, :with_summary, user: other_user)
        resume
      end

      it "他人の経歴書は閲覧できないこと" do
        get "/api/v1/resumes/#{other_user_resume.id}"
        expect(response.status).to eq 403
      end
    end
  end

  describe "POST /api/v1/resumes" do
    context '有効なパラメータの場合' do
      let(:valid_params) do
        {
          resume: {
            user_id: user.id
          }
        }
      end

      it '経歴書が作成される' do
        expect {
          post '/api/v1/resumes', params: valid_params
        }.to change(Resume, :count).by(1)
      end

      it 'ステータス201が返る' do
        post '/api/v1/resumes', params: valid_params
        expect(response).to have_http_status(:created)
      end

      it '作成された経歴書がJSONで返る' do
        post '/api/v1/resumes', params: valid_params
        json = JSON.parse(response.body)

        expect(json['user_id']).to eq(user.id)
        expect(json['summary']).to be_nil
      end
    end

    context 'summaryを含むパラメータの場合' do
      let(:params_with_summary) do
        {
          resume: {
            user_id: user.id,
            summary: '私は株式会社ABCで営業として働きました。'
          }
        }
      end

      it 'summaryを含む経歴書が作成される' do
        expect {
          post '/api/v1/resumes', params: params_with_summary
        }.to change(Resume, :count).by(1)
      end

      it '作成された経歴書にsummaryが含まれる' do
        post '/api/v1/resumes', params: params_with_summary
        json = JSON.parse(response.body)

        expect(json['summary']).to eq('私は株式会社ABCで営業として働きました。')
      end
    end

    context '無効なパラメータの場合（user_idなし）' do
      let(:invalid_params) do
        {
          resume: {
            user_id: nil
          }
        }
      end

      it '経歴書が作成されない' do
        expect {
          post '/api/v1/resumes', params: invalid_params
        }.not_to change(Resume, :count)
      end

      it 'ステータス422が返る' do
        post '/api/v1/resumes', params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'エラーメッセージがJSONで返る' do
        post '/api/v1/resumes', params: invalid_params
        json = JSON.parse(response.body)

        expect(json['errors']).to be_present
      end
    end

    context '既に経歴書が存在するユーザーの場合' do
      let!(:existing_resume) { create(:resume, user: user) }
      let(:duplicate_params) do
        {
          resume: {
            user_id: user.id
          }
        }
      end

      it '経歴書が作成されない（一意制約）' do
        expect {
          post '/api/v1/resumes', params: duplicate_params
        }.not_to change(Resume, :count)
      end

      it 'ステータス422が返る' do
        post '/api/v1/resumes', params: duplicate_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'エラーメッセージがJSONで返る' do
        post '/api/v1/resumes', params: duplicate_params
        json = JSON.parse(response.body)

        expect(json['errors']).to be_present
        expect(json['errors']).to include("はすでに存在します")
      end
    end
  end

  xdescribe "PATCH /api/v1/resumes" do

  end
end
