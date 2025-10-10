class Task < ApplicationRecord
  belongs_to :work_experience

  validates :content, presence: true
end
