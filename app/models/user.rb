class User < ApplicationRecord
  has_many :resumes, dependent: :destroy
  has_many :career_profiles, dependent: :destroy
  has_many :work_experiences, through: :career_profiles

  self.inheritance_column = :type
end
