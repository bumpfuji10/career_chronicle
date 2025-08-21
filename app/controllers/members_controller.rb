class MembersController < ApplicationController

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      session[:user_id] = @member.id
      flash[:notice] = "ユーザー登録が完了しました。"
      redirect_to root_path
    else
      flash.now[:alert] = @member.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private

  def member_params
    params.require(:member).permit(:name, :email, :password)
  end
end
