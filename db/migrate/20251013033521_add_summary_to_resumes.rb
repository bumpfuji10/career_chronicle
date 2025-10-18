class AddSummaryToResumes < ActiveRecord::Migration[7.1]
  def change
    add_column :resumes, :summary, :text
  end
end
