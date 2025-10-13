class Resume < ApplicationRecord
  belongs_to :user
  has_many :companies, dependent: :destroy

  validates :user_id, presence: true, uniqueness: true
  validates :summary, length: { maximum: 10_000 }, allow_blank: true
end
