class AddStartAtAndEndAtToResume < ActiveRecord::Migration[7.1]
  def up
    add_column :resumes, :start_at, :date
    add_column :resumes, :end_at, :date

    # 既存データを埋める
    execute <<-SQL
      UPDATE resumes
      SET start_at = created_at::date
      WHERE start_at IS NULL
    SQL

    change_column_null :resumes, :start_at, false
    add_index :resumes, :start_at
  end

  def down
    remove_index :resumes, :start_at
    remove_column :resumes, :start_at
    remove_column :resumes, :end_at
  end
end
