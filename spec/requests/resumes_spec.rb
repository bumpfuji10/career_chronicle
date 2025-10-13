require 'rails_helper'

RSpec.describe "職務経歴書", type: :request do
  before(:each) do
    # 各テスト前にゲストユーザーとresumeをクリーンアップ
    Resume.destroy_all
    Guest.destroy_all
  end
  
  describe "GET /resumes/new" do
    context "セッションにゲストユーザーが存在しない場合" do
      it "新しいゲストユーザーを作成してセッションに保存する" do
        expect {
          get new_resume_path
        }.to change { Guest.count }.by(1)

        expect(response).to have_http_status(:success)
        
        # Guestが作成されたことを確認
        guest_user = Guest.last
        expect(guest_user).to be_present
        expect(guest_user.session_token).to be_present
      end
    end

    context "セッションにゲストユーザーが既に存在する場合" do
      it "新しいゲストユーザーを作成しない" do
        # 最初のリクエストでゲストユーザーを作成
        get new_resume_path
        expect(response).to have_http_status(:success)
        initial_count = Guest.count

        # 2回目のリクエストでは新しいゲストユーザーは作成されないが、
        # resumeが既に存在するのでリダイレクトされる
        get new_resume_path
        expect(Guest.count).to eq(initial_count)
        expect(response).to have_http_status(:redirect)
      end

      it "既存のゲストユーザーを使用する" do
        # 最初のリクエストでゲストユーザーを作成
        get new_resume_path
        first_guest_user = Guest.last

        # 2回目のリクエストでも同じゲストユーザーが使用される
        # ただし、resumeが既に存在するのでリダイレクトされる
        get new_resume_path
        expect(Guest.last).to eq(first_guest_user)
        expect(Guest.count).to eq(1) # 1つだけ存在
        expect(response).to have_http_status(:redirect)
      end
    end

    context "resumeの作成" do
      it "初回アクセス時に空のresumeが作成される" do
        expect {
          get new_resume_path
        }.to change { Resume.count }.by(1)

        # 作成されたresumeを確認
        resume = Resume.last
        expect(resume).to be_present
        expect(resume.user).to be_a(Guest)

        # レスポンスにresumeのidが含まれることを確認
        expect(response.body).to include("data-resume-id=\"#{resume.id}\"")
      end

      it "resumeが既に存在する場合は新しく作成しない" do
        # 最初のリクエストでresumeを作成
        get new_resume_path
        expect(Resume.count).to eq(1)

        # 2回目のリクエストではリダイレクトされる（ゲストは1件のみ）
        get new_resume_path
        expect(response).to have_http_status(:redirect)
        expect(Resume.count).to eq(1)
      end

      it "ゲストユーザーは2件目のresumeを作成できない" do
        # 最初のリクエストでresumeを作成
        get new_resume_path

        # 2回目のリクエストではリダイレクトされる
        get new_resume_path
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)

        # flashメッセージを確認
        follow_redirect!
        expect(response.body).to include("ゲストユーザーは職務経歴書を1件までしか作成できません")
      end
    end
  end

end