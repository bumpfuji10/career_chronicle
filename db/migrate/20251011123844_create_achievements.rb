class CreateAchievements < ActiveRecord::Migration[7.1]
  def change
    create_table :achievements do |t|
      t.references :task, null: false, foreign_key: true
      t.text :content, null: false

      t.timestamps
    end
  end
end
