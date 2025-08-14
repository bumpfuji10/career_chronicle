class User < ApplicationRecord
  has_many :resumes, dependent: :destroy
  self.inheritance_column = :type
end
