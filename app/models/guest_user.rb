class GuestUser < ApplicationRecord
  has_many :resumes, dependent: :destroy
  
  validates :session_token, presence: true, uniqueness: true
end
