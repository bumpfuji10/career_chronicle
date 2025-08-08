class ProvideGuestUser
  # 入力値
  def initialize(session)
    @session = session
  end

  def call
    find_guest_user || create_guest_user
  end

  private

  def find_guest_user
    token = @session[:guest_user_token]
    return unless token
    
    GuestUser.find_by(session_token: token)
  end

  def create_guest_user
    token = SecureRandom.hex(16)
    guest_user = GuestUser.create!(session_token: token)
    @session[:guest_user_token] = token
    guest_user
  end
end