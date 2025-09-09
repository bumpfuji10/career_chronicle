class ApplicationController < ActionController::Base
  helper_method :current_member, :logged_in?
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found


  private

  def current_member
    @current_member ||= Member.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_guest
    @current_guest ||= ProvideGuestUser.new(session).call
  end

  def logged_in?
    !!current_member
  end

  def render_not_found
    respond_to do |format|
      format.html { redirect_to root_path, alert: "職務経歴書が見つかりませんでした" }
    end
  end
end
