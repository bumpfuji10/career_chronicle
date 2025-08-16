class ApplicationController < ActionController::Base
  helper_method :current_member, :logged_in?

  private

  def current_member
    @current_member ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_member
  end
end
