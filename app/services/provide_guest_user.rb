class ProvideGuestUser
  # 入力値
  def initialize(session)
    @session = session
  end

  def call
    guest_user = find_guest_user || create_guest_user
    update_expiration if guest_user
    guest_user
  end

  private

  def find_guest_user
    token = @session[:guest_user_token]
    return unless token
    
    # セッションの有効期限をチェック
    expiration = @session[:guest_user_expires_at]
    return if expiration.nil? || Time.current > Time.parse(expiration.to_s)
    
    Guest.find_by(session_token: token)
  end

  def create_guest_user
    token = SecureRandom.hex(16)
    guest_user = Guest.new
    guest_user.session_token = token
    guest_user.save!
    @session[:guest_user_token] = token
    update_expiration
    guest_user
  end

  def update_expiration
    # セッションの有効期限を1週間後に設定
    @session[:guest_user_expires_at] = 1.week.from_now.iso8601
  end
end