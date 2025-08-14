class Guest < User
  validates :session_token, presence: true, uniqueness: true
  
  before_validation :set_default_name, on: :create
  
  private
  
  def set_default_name
    self.name ||= 'ゲストユーザー'
  end
end