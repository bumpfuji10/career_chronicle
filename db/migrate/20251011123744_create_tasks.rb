class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.references :position, null: false, foreign_key: true
      t.text :content, null: false

      t.timestamps
    end
  end
end
