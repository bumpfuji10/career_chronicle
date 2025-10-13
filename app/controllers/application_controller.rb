class ApplicationController < ActionController::Base
  helper_method :current_member, :current_guest, :logged_in?
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from UnauthorizedError, with: :render_forbidden

  private

  # 既存のゲストユーザーを取得（作成しない）
  def current_guest
    return nil unless session[:guest_token]
    @current_guest ||= Guest.find_by(session_token: session[:guest_token])
  end

  # ゲストユーザーを作成（必要な時のみ明示的に呼ぶ）
  def create_guest_user!
    return current_guest if current_guest

    guest = Guest.create!(session_token: SecureRandom.hex(16))
    session[:guest_token] = guest.session_token
    @current_guest = guest
  end

  def current_user
    current_member || current_guest
  end

  def current_member
    @current_member ||= Member.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_member
  end

  def render_not_found
    respond_to do |format|
      format.html { redirect_to root_path, alert: "職務経歴書が見つかりませんでした" }
    end
  end

  def render_forbidden
    respond_to do |format|
      format.html { redirect_to root_path, alert: "アクセス権限がありません"}
    end
  end
end
