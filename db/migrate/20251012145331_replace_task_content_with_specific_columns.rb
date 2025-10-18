class ReplaceTaskContentWithSpecificColumns < ActiveRecord::Migration[7.1]
  def change
    # contentカラムを削除
    remove_column :tasks, :content, :text

    # 新しいカラムを追加
    add_column :tasks, :task_description, :text, null: false
    add_column :tasks, :improvement, :text, null: false
  end
end
