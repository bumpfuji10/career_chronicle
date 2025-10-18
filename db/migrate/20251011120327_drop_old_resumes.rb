class DropOldResumes < ActiveRecord::Migration[7.1]
  def up
    # 既存データを完全に削除
    drop_table :resumes
  end

  def down
    # ロールバック時に元の構造を復元（念のため）
    create_table :resumes do |t|
      t.string :company, null: false
      t.string :position, null: false
      t.text :tasks, null: false
      t.text :improvements, null: false
      t.text :achievements, null: false
      t.text :summary, null: false
      t.bigint :user_id
      t.date :start_at, null: false
      t.date :end_at
      t.timestamps
    end

    add_index :resumes, :start_at
    add_index :resumes, :user_id
    add_foreign_key :resumes, :users
  end
end
