class ResumesController < ApplicationController
  before_action :set_user
  before_action :deny_guest_access!, except: [:new, :show]
  before_action :check_guest_resume_limit, only: [:new]
  before_action :set_resume, only: [:show]
  before_action :authorize_resume!, only: [:show]

  def new
    # 既に resume が存在する場合はそれを使用、なければ新規作成
    @resume = @user.resume || @user.create_resume!
  end

  def show; end

  def index
    @resumes = @user.resume
  end

  private

  # memberもしくはguestを返す
    # guestはセッションを有している、有効期限内のuserに限る
    # guestが存在しない場合は、現時刻を有効期限として、guestを作成する
  def set_user
    @user = current_member || current_guest || create_guest_user!
  end

  def deny_guest_access!
    if @user.is_a?(Guest)
      raise UnauthorizedError
    end
  end

  def check_guest_resume_limit
    if @user.is_a?(Guest) && @user.resume.present?
      redirect_to root_path, alert: "ゲストユーザーは職務経歴書を1件までしか作成できません。アカウントの登録もしくはログインをしていただくことで2件目の作成が可能となっております。"
    end
  end

  def authorize_resume!
    resume_owner_id = current_member&.id || current_guest&.id

    if resume_owner_id != @resume.user_id
      raise UnauthorizedError
    end
  end

  def set_resume
    @resume = Resume.find_by!(id: params[:id])
  end
end
