require 'rails_helper'

RSpec.describe "職務経歴書", type: :request do
  before(:each) do
    # 各テスト前にゲストユーザーをクリーンアップ
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
        
        # 2回目のリクエストでは新しいゲストユーザーは作成されない
        get new_resume_path
        expect(Guest.count).to eq(initial_count)
        expect(response).to have_http_status(:success)
      end

      it "既存のゲストユーザーを使用する" do
        # 最初のリクエストでゲストユーザーを作成
        get new_resume_path
        first_guest_user = Guest.last

        # 2回目のリクエストでも同じゲストユーザーが使用される
        get new_resume_path
        expect(response).to have_http_status(:success)
        expect(Guest.last).to eq(first_guest_user)
        expect(Guest.count).to eq(1) # 1つだけ存在
      end
    end
  end
end