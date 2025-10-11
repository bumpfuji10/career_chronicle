class Task < ApplicationRecord
  belongs_to :position
  has_many :achievements, dependent: :destroy

  validates :content, presence: true
end
