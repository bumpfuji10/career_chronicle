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
    
    Guest.find_by(session_token: token)
  end

  def create_guest_user
    token = SecureRandom.hex(16)
    guest_user = Guest.new
    guest_user.session_token = token
    guest_user.save!
    @session[:guest_user_token] = token
    guest_user
  end
end