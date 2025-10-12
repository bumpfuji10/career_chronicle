class Task < ApplicationRecord
  belongs_to :position
  has_many :achievements, dependent: :destroy

  validates :task_description, presence: true
  validates :improvement, presence: true
end
