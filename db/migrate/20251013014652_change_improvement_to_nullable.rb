class ChangeImprovementToNullable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :tasks, :improvement, true
  end
end
