class Resume < ApplicationRecord
  validates :company, presence: true
  validates :position, presence: true
  validates :tasks, presence: true
  validates :improvements, presence: true
  validates :achievements, presence: true
  validates :summary, presence: true

  belongs_to :user

  def generate_summary
    "私は#{company}で#{position}として、#{tasks}。その中で#{improvements}。結果として#{achievements}。"
  end
end
