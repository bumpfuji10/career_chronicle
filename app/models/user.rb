class User < ApplicationRecord
  has_one :resume, dependent: :destroy

  self.inheritance_column = :type

  def is_guest?
    self.is_a?(Guest)
  end
end
