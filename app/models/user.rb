class User < ApplicationRecord
  has_one :resume, dependent: :destroy

  self.inheritance_column = :type
end
