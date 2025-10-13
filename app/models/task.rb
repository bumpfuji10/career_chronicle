class Task < ApplicationRecord
  belongs_to :position
  has_many :achievements, dependent: :destroy

  validates :task_description, presence: true
  # improvement は任意項目（後から追記可能）
end
