class CreateCareerProfileStructure < ActiveRecord::Migration[7.1]
  def change
    create_table :career_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.timestamps
    end

    create_table :work_experiences do |t|
      t.references :career_profile, null: false, foreign_key: true
      t.string :company, null: false
      t.string :position, null: false
      t.date :start_at, null: false
      t.date :end_at
      t.boolean :is_current, default: false
      t.integer :display_order
      t.timestamps
    end

    create_table :tasks do |t|
      t.references :work_experience, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :display_order
      t.timestamps
    end

    create_table :improvements do |t|
      t.references :work_experience, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :display_order
      t.timestamps
    end

    create_table :achievements do |t|
      t.references :work_experience, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :display_order
      t.timestamps
    end

    create_table :experience_summaries do |t|
      t.references :work_experience, null: false, foreign_key: true
      t.text :content, null: false
      t.timestamps
    end
  end
end
