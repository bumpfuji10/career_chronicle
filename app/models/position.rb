class Position < ApplicationRecord
  belongs_to :company
  has_many :tasks, dependent: :destroy

  validates :title, presence: true
  validates :department, presence: true
  validates :started_at, presence: true
end
