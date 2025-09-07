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

      context "存在しない経歴書へのアクセスをした場合" do

        it "404エラーが発生すること" do
          expect {
            get :show, params: { id: 99999 }, session: guest_session_data
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context "メンバー" do
      let(:member) { FactoryBot.create(:registered_user) }

      before do
        # メンバーとしてログイン
        session[:user_id] = member.id
      end

      context "経歴書を作成済みの場合" do
        let(:resume) { FactoryBot.create(:resume, user_id: member.id) }
        
        context "自分の経歴書" do
          it "アクセス可能なこと" do
            get :show, params: { id: resume.id }
            expect(response.status).to eq 200
          end
        end

        context "他人の経歴書にアクセスした場合" do
          let(:other_member) { FactoryBot.create(:registered_user) }
          let(:other_members_resume) {
            FactoryBot.create(:resume, user_id: other_member.id)
          }
          
          it "ステータスコード302が返却されること" do
            get :show, params: { id: other_members_resume.id }
            expect(response.status).to eq 302
          end
          
          it "アクセス権限がない旨のflashメッセージが表示されること" do
            get :show, params: { id: other_members_resume.id }
            expect(flash[:alert]).to eq "アクセス権限がありません"
          end
        end
      end

      context "存在しない経歴書へのアクセスをした場合" do
        it "404エラーが発生すること" do
          expect {
            get :show, params: { id: 99999 }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "#new" do
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
      before do
        session[:guest_user_id] = guest.id
      end
      context "初めて職務経歴書を作成する場合" do
        it "アクセスが成功すること" do
          get :new
          expect(response.status).to eq 200
        end
      end

      context "既に職務経歴書を作成済みの場合" do
        let!(:resume) {
          FactoryBot.create(:resume, user_id: guest.id)
        }
        it "アクセスが失敗すること" do
          get :new, session: guest_session_data
          expect(response.status).to eq 302
        end
      end
    end

    context "メンバー" do
      let(:member) { FactoryBot.create(:registered_user) }
      before do
        session[:user_id] = member.id
      end
      it "アクセスが成功すること" do
        get :new
        expect(response.status).to eq 200
      end
    end
  end
end