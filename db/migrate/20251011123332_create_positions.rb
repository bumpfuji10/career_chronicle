class CreatePositions < ActiveRecord::Migration[7.1]
  def change
    create_table :positions do |t|
      t.references :company, null: false, foreign_key: true
      t.string :title, null: false
      t.date :started_at, null: false
      t.date :ended_at, null: false
      t.text :description, null: false

      t.timestamps
    end

    add_index :positions, :started_at
  end
end
