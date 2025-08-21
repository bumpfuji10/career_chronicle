class ApplicationController < ActionController::Base
  helper_method :current_member, :logged_in?

  private

  def current_member
    @current_member ||= Member.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_guest
    # メンバーがログインしている場合はゲストユーザーを返さない
    return nil if logged_in?
    if logged_in?
      pp "hogehoge"
      pp "hogehoge"
      pp "hogehoge"
      return nil
    end
    @current_guest ||= ProvideGuestUser.new(session).call
  end

  def logged_in?
    !!current_member
  end
end
