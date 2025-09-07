require 'rails_helper'

RSpec.describe ResumesController, type: :controller do
  describe '#show' do
    context "ゲストユーザー" do
      let(:guest) {
        guest_token = SecureRandom.hex(16)
        FactoryBot.create(:guest_user, session_token: guest_token)
      }
      let(:guest_session_data) do
        {
          guest_user_token: guest.session_token,
          guest_user_expires_at: 1.week.from_now.iso8601
        }
      end
      
      context "経歴書を作成済みの場合" do
        let(:resume) { FactoryBot.create(:resume, user_id: guest.id) }
        context "自分の経歴書" do
          it "アクセス可能なこと" do
            get :show, params: { id: resume.id }, session: guest_session_data
            expect(response.status).to eq 200
          end
        end

        context "他人の経歴書にアクセスした場合" do
          let(:other_guest) { FactoryBot.create(:guest_user)}
          let(:other_guests_resume) {
            FactoryBot.create(:resume, user_id: other_guest.id)
          }
          it "ステータスコード301が返却されること" do
            get :show, params: { id: other_guests_resume.id }, session: guest_session_data
            expect(response.status).to eq 302
          end
          
          it "アクセス権限がない旨のflashメッセージが表示されること" do
            get :show, params: { id: other_guests_resume.id }, session: guest_session_data
            expect(flash[:alert]).to eq "アクセス権限がありません"
          end
        end

      end

      context "経歴書を作成していない場合" do

        it "アクセス権限がないこと" do

        end
      end
    end

    context "メンバー" do

    end
  end
end