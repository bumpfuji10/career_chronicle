class Company < ApplicationRecord
  belongs_to :resume
  has_many :positions, dependent: :destroy

  validates :name, presence: true
  validates :industry, presence: true
  validates :started_at, presence: true
  validates :description, presence: true
end
