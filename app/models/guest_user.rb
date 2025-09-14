class GuestUser < ApplicationRecord
  validates :session_token, presence: true, unique: true
end
