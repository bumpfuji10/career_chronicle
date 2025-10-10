class CareerProfile < ApplicationRecord
  belongs_to :user
  has_many :work_experiences, dependent: :destroy
end
