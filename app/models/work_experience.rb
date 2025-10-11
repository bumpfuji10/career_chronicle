class WorkExperience < ApplicationRecord
  belongs_to :career_profile
  has_many :tasks, dependent: :destroy
  has_many :improvements, dependent: :destroy
  has_many :achievements, dependent: :destroy
  has_one :experience_summary, dependent: :destroy

  validates :company, presence: true
  validates :position, presence: true
  validates :start_at, presence: true

  def generate_summary
    task_text = tasks.order(:display_order, :id).first&.content || '業務を担当'
    improvement_text = improvements.order(:display_order, :id).first&.content || '工夫を行い'
    achievement_text = achievements.order(:display_order, :id).first&.content || '成果を上げました'

    "私は#{company}で#{position}として、#{task_text}。その中で#{improvement_text}。結果として#{achievement_text}。"
  end
end
