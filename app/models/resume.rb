class Resume < ApplicationRecord
  belongs_to :user
  has_many :companies, dependent: :destroy

  validates :user_id, presence: true, uniqueness: true
  validates :summary, length: { maximum: 10_000 }, allow_blank: true

  # 職務経歴書のサマリーテキストを生成
  def generate_summary_data
    companies.order(started_at: :desc).includes(positions: { tasks: :achievements }).map do |company|
      company_section(company)
    end.join("\n\n")
  end

  private

  def company_section(company)
    company.positions.order(started_at: :desc).map do |position|
      position_section(company, position)
    end.join("\n\n")
  end

  def position_section(company, position)
    period = format_period(position.started_at, position.ended_at)
    header = "■ #{company.name} / #{position.department} #{position.title} (#{period})\n\n"

    tasks_text = position.tasks.map do |task|
      task_bullet(task)
    end.join("\n")

    header + tasks_text
  end

  def task_bullet(task)
    parts = [task.task_description]
    parts << task.improvement if task.improvement.present?

    if task.achievements.any?
      achievements_text = task.achievements.map(&:content).join('。')
      parts << achievements_text
    end

    "・#{parts.join('。')}"
  end

  def format_period(started_at, ended_at)
    start_str = started_at.strftime('%Y年%m月')
    end_str = ended_at ? ended_at.strftime('%Y年%m月') : '現在'
    "#{start_str} 〜 #{end_str}"
  end
end
