class AddNotNullConstraintsToResumes < ActiveRecord::Migration[7.1]
  def change
    change_column_null :resumes, :company, false
    change_column_null :resumes, :position, false
    change_column_null :resumes, :tasks, false
    change_column_null :resumes, :improvements, false
    change_column_null :resumes, :achievements, false
    change_column_null :resumes, :summary, false
  end
end