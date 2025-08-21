class User < ApplicationRecord
  has_many :resumes, dependent: :destroy
  has_secure_password
  
  self.inheritance_column = :type
end
