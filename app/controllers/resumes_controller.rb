class ResumesController < ApplicationController
  before_action :set_user
  before_action :check_guest_resume_limit, only: [:new]
  before_action :set_resume, only: [:show]
  before_action :authorize_resume!, only: [:show]

  def new; end

  def show; end

  private

  def set_user
    @user = current_member || current_guest
  end

  def check_guest_resume_limit
    if @user.is_a?(Guest) && @user.resumes.exists?
      redirect_to root_path, alert: "ゲストユーザーは職務経歴書を1件までしか作成できません。アカウントの登録もしくはログインをしていただくことで2件目の作成が可能となっております。"
    end
  end

  def authorize_resume!
    resume_owner_id = current_member&.id || current_guest&.id

    if resume_owner_id != @resume.user_id 
      redirect_to root_path, alert: "アクセス権限がありません"
    end
  end

  def set_resume
    @resume = Resume.find(params[:id])
  end
end
