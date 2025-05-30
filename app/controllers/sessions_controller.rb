class SessionsController < ApplicationController
  def new; end

  def create
    user = User.authenticate_by(email: params[:email], password: params[:password])

    if user
      session[:user_id] = user.id
      flash[:notice] = "ログインしました。"
      redirect_to root_path
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      render :new, status: :unprocessable_entity
    end
  end
end
