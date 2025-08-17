class ResumesController < ApplicationController
  before_action :set_user
  before_action :check_guest_resume_limit, only: [:new]
  before_action :set_resume, only: [:show]

  def new; end

  def show
    # ゲストユーザーは自分のresumeのみ閲覧可能
    if @user.is_a?(Guest) && @resume.user_id != @user.id
      redirect_to root_path, alert: "アクセス権限がありません"
    end
  end

  private

  def set_user
    @user = current_member || current_guest
  end

  def check_guest_resume_limit
    if @user.is_a?(Guest) && @user.resumes.exists?
      redirect_to "/", alert: "ゲストユーザーは職務経歴書を1件までしか作成できません。アカウントの登録もしくはログインをしていただくことで2件目の作成が可能となっております。"
    end
  end

  def set_resume
    @resume = Resume.find(params[:id])
  end
end
