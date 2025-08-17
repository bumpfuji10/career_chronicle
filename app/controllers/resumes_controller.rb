class ResumesController < ApplicationController
  before_action :set_user
  before_action :check_guest_resume_limit, only: [:new]

  def new; end

  private

  def set_user
    @user = current_member || current_guest
  end

  def check_guest_resume_limit
    if @user.is_a?(Guest) && @user.resumes.exists?
      redirect_to "/", alert: "ゲストユーザーは職務経歴書を1件までしか作成できません。アカウントの登録もしくはログインをしていただくことで2件目の作成が可能となっております。"
    end
  end
end
