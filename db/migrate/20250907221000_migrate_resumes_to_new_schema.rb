class MigrateResumesToNewSchema < ActiveRecord::Migration[7.1]
  class CareerProfile < ApplicationRecord
    self.table_name = 'career_profiles'
    has_many :work_experiences
  end

  class WorkExperience < ApplicationRecord
    self.table_name = 'work_experiences'
    belongs_to :career_profile
    has_many :tasks
    has_many :improvements
    has_many :achievements
    has_one :experience_summary
  end

  class Task < ApplicationRecord
    self.table_name = 'tasks'
    belongs_to :work_experience
  end

  class Improvement < ApplicationRecord
    self.table_name = 'improvements'
    belongs_to :work_experience
  end

  class Achievement < ApplicationRecord
    self.table_name = 'achievements'
    belongs_to :work_experience
  end

  class ExperienceSummary < ApplicationRecord
    self.table_name = 'experience_summaries'
    belongs_to :work_experience
  end

  class Resume < ApplicationRecord
    self.table_name = 'resumes'
  end

  def up
    Resume.find_each do |resume|
      career_profile = CareerProfile.create!(user_id: resume.user_id)

      work_experience = WorkExperience.create!(
        career_profile: career_profile,
        company: resume.company,
        position: resume.position,
        start_at: resume.start_at,
        end_at: resume.end_at,
        is_current: resume.end_at.nil?
      )

      Task.create!(work_experience: work_experience, content: resume.tasks) if resume.tasks.present?
      Improvement.create!(work_experience: work_experience, content: resume.improvements) if resume.improvements.present?
      Achievement.create!(work_experience: work_experience, content: resume.achievements) if resume.achievements.present?
      ExperienceSummary.create!(work_experience: work_experience, content: resume.summary) if resume.summary.present?
    end
  end

  def down
    CareerProfile.destroy_all
  end
end
