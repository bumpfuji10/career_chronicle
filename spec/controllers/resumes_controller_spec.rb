require 'rails_helper'

RSpec.describe ResumesController, type: :controller do
  describe 'ゲストユーザーの職務経歴書作成制限' do
    let(:guest) { create(:guest_user) }
    let(:member) { create(:user) }

    describe 'GET #new' do
      context 'ゲストユーザーとしてアクセスする場合' do
        before do
          allow(controller).to receive(:current_guest).and_return(guest)
          allow(controller).to receive(:current_member).and_return(nil)
        end

        context '職務経歴書を未作成のゲストユーザーの場合' do
          it '正常に職務経歴書作成ページにアクセスできる' do
            get :new
            expect(response).to have_http_status(:success)
          end

          it 'リダイレクトされない' do
            get :new
            expect(response).not_to redirect_to("/")
          end
        end

        context '既に職務経歴書を1件作成済みのゲストユーザーの場合' do
          before do
            # ゲストユーザーに既に職務経歴書を作成
            Resume.create!(
              user: guest,
              company: '既存の会社',
              position: 'エンジニア',
              tasks: '開発業務',
              improvements: '改善活動',
              achievements: '成果',
              summary: '私は既存の会社でエンジニアとして、開発業務。その中で改善活動。結果として成果。'
            )

          end

          it 'トップページにリダイレクトされる' do
            get :new
            expect(response).to redirect_to("/")
          end

          it '適切なアラートメッセージが表示される' do
            get :new
            expected_message = "ゲストユーザーは職務経歴書を1件までしか作成できません。アカウントの登録もしくはログインをしていただくことで2件目の作成が可能となっております。"
            expect(flash[:alert]).to eq(expected_message)
          end

          it '複数回アクセスしても同じ制限が適用される' do
            # 1回目のアクセス
            get :new
            expect(response).to redirect_to("/")
            
            # 2回目のアクセス
            get :new
            expect(response).to redirect_to("/")
            expect(flash[:alert]).to include("ゲストユーザーは職務経歴書を1件までしか作成できません")
          end
        end

        context '複数の職務経歴書を持つゲストユーザーの場合（データ不整合）' do
          before do
            # データ不整合をシミュレート：ゲストユーザーが複数の職務経歴書を持つ
            2.times do |i|
              Resume.create!(
                user: guest,
                company: "会社#{i+1}",
                position: 'エンジニア',
                tasks: '開発業務',
                improvements: '改善活動',
                achievements: '成果',
                summary: "私は会社#{i+1}でエンジニアとして、開発業務。その中で改善活動。結果として成果。"
              )
            end
          end

          it 'トップページにリダイレクトされる' do
            get :new
            expect(response).to redirect_to("/")
          end

          it '制限メッセージが表示される' do
            get :new
            expect(flash[:alert]).to include("ゲストユーザーは職務経歴書を1件までしか作成できません")
          end
        end
      end

      context '通常の会員ユーザーとしてアクセスする場合' do
        before do
          allow(controller).to receive(:current_member).and_return(member)
          allow(controller).to receive(:current_guest).and_return(nil)
        end

        context '職務経歴書を未作成の会員ユーザーの場合' do
          it '正常に職務経歴書作成ページにアクセスできる' do
            get :new
            expect(response).to have_http_status(:success)
          end
        end

        context '既に職務経歴書を1件作成済みの会員ユーザーの場合' do
          before do
            Resume.create!(
              user: member,
              company: '既存の会社',
              position: 'エンジニア',
              tasks: '開発業務',
              improvements: '改善活動',
              achievements: '成果',
              summary: '私は既存の会社でエンジニアとして、開発業務。その中で改善活動。結果として成果。'
            )
          end

          it '正常に職務経歴書作成ページにアクセスできる（制限なし）' do
            get :new
            expect(response).to have_http_status(:success)
          end

          it 'リダイレクトされない' do
            get :new
            expect(response).not_to redirect_to("/")
          end

          it 'アラートメッセージが表示されない' do
            get :new
            expect(flash[:alert]).to be_nil
          end
        end

        context '複数の職務経歴書を作成済みの会員ユーザーの場合' do
          before do
            3.times do |i|
              Resume.create!(
                user: member,
                company: "会社#{i+1}",
                position: 'エンジニア',
                tasks: '開発業務',
                improvements: '改善活動',
                achievements: '成果',
                summary: "私は会社#{i+1}でエンジニアとして、開発業務。その中で改善活動。結果として成果。"
              )
            end
          end

          it '正常に職務経歴書作成ページにアクセスできる（制限なし）' do
            get :new
            expect(response).to have_http_status(:success)
          end

          it 'アラートメッセージが表示されない' do
            get :new
            expect(flash[:alert]).to be_nil
          end
        end
      end

      context 'ログインしていないユーザーの場合' do
        before do
          allow(controller).to receive(:current_member).and_return(nil)
          allow(controller).to receive(:current_guest).and_return(nil)
        end

        it '正常に職務経歴書作成ページにアクセスできる' do
          get :new
          expect(response).to have_http_status(:success)
        end

        it 'アラートメッセージが表示されない' do
          get :new
          expect(flash[:alert]).to be_nil
        end
      end
    end

    describe 'エッジケースのテスト' do
      context 'ゲストユーザーのセッションが途中で切れた場合' do
        before do
          allow(controller).to receive(:current_guest).and_return(guest)
          allow(controller).to receive(:current_member).and_return(nil)
        end

        it '職務経歴書がない状態でセッションが切れてもエラーにならない' do
          # セッションが切れた状態をシミュレート
          allow(controller).to receive(:current_guest).and_return(nil)
          
          get :new
          expect(response).to have_http_status(:success)
        end
      end

      context 'ゲストから会員にアップグレードした場合' do
        before do
          # 最初はゲストユーザーとして職務経歴書を作成
          Resume.create!(
            user: guest,
            company: 'ゲスト時代の会社',
            position: 'エンジニア',
            tasks: '開発業務',
            improvements: '改善活動',
            achievements: '成果',
            summary: '私はゲスト時代の会社でエンジニアとして、開発業務。その中で改善活動。結果として成果。'
          )
          
          # その後、会員にアップグレード（会員としてログイン）
          allow(controller).to receive(:current_member).and_return(member)
          allow(controller).to receive(:current_guest).and_return(nil)
        end

        it '会員として新しい職務経歴書を作成できる' do
          get :new
          expect(response).to have_http_status(:success)
          expect(flash[:alert]).to be_nil
        end
      end
    end
  end

  describe 'GET #show' do
    let(:guest) { create(:guest_user) }
    let(:member) { create(:user) }
    let(:other_guest) { create(:guest_user) }
    let!(:guest_resume) do
      Resume.create!(
        user: guest,
        company: 'ゲストの会社',
        position: 'エンジニア',
        tasks: '開発業務',
        improvements: '改善活動',
        achievements: '成果',
        summary: '私はゲストの会社でエンジニアとして、開発業務。その中で改善活動。結果として成果。'
      )
    end
    let!(:member_resume) do
      Resume.create!(
        user: member,
        company: '会員の会社',
        position: 'デザイナー',
        tasks: 'デザイン業務',
        improvements: 'UI改善',
        achievements: 'UX向上',
        summary: '私は会員の会社でデザイナーとして、デザイン業務。その中でUI改善。結果としてUX向上。'
      )
    end

    context 'ゲストユーザーとしてアクセスする場合' do
      before do
        allow(controller).to receive(:current_guest).and_return(guest)
        allow(controller).to receive(:current_member).and_return(nil)
      end

      context '自分の職務経歴書を閲覧する場合' do
        it '正常に職務経歴書詳細ページが表示される' do
          get :show, params: { id: guest_resume.id }
          expect(response).to have_http_status(:success)
        end

        it 'リダイレクトされない' do
          get :show, params: { id: guest_resume.id }
          expect(response).not_to redirect_to(root_path)
        end
      end

      context '他のユーザーの職務経歴書を閲覧しようとする場合' do
        it 'トップページにリダイレクトされる' do
          get :show, params: { id: member_resume.id }
          expect(response).to redirect_to(root_path)
        end

        it 'アクセス権限エラーメッセージが表示される' do
          get :show, params: { id: member_resume.id }
          expect(flash[:alert]).to eq("アクセス権限がありません")
        end
      end

      context '他のゲストユーザーの職務経歴書を閲覧しようとする場合' do
        let!(:other_guest_resume) do
          Resume.create!(
            user: other_guest,
            company: '他のゲストの会社',
            position: 'マネージャー',
            tasks: '管理業務',
            improvements: 'プロセス改善',
            achievements: '効率化',
            summary: '私は他のゲストの会社でマネージャーとして、管理業務。その中でプロセス改善。結果として効率化。'
          )
        end

        it 'トップページにリダイレクトされる' do
          get :show, params: { id: other_guest_resume.id }
          expect(response).to redirect_to(root_path)
        end

        it 'アクセス権限エラーメッセージが表示される' do
          get :show, params: { id: other_guest_resume.id }
          expect(flash[:alert]).to eq("アクセス権限がありません")
        end
      end
    end

    context '会員ユーザーとしてアクセスする場合' do
      before do
        allow(controller).to receive(:current_member).and_return(member)
        allow(controller).to receive(:current_guest).and_return(nil)
      end

      context '自分の職務経歴書を閲覧する場合' do
        it '正常に職務経歴書詳細ページが表示される' do
          get :show, params: { id: member_resume.id }
          expect(response).to have_http_status(:success)
        end

        it 'リダイレクトされない' do
          get :show, params: { id: member_resume.id }
          expect(response).not_to redirect_to(root_path)
        end
      end

      context '他のユーザーの職務経歴書を閲覧する場合' do
        it '正常に職務経歴書詳細ページが表示される（会員は制限なし）' do
          get :show, params: { id: guest_resume.id }
          expect(response).to have_http_status(:success)
        end
      end
    end

    context '存在しない職務経歴書IDを指定した場合' do
      before do
        allow(controller).to receive(:current_guest).and_return(guest)
        allow(controller).to receive(:current_member).and_return(nil)
      end

      it 'RecordNotFoundエラーが発生する' do
        expect {
          get :show, params: { id: 99999 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end