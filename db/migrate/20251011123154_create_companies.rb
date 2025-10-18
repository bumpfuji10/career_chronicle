class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :name, null: false
      t.string :industry, null: false
      t.date :started_at, null: false
      t.date :ended_at, null: false
      t.text :description, null: false

      t.timestamps
    end

    add_index :companies, :started_at
  end
end
