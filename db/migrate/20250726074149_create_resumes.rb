class CreateResumes < ActiveRecord::Migration[7.1]
  def change
    create_table :resumes do |t|
      t.string :company
      t.string :position
      t.text :tasks
      t.text :improvements
      t.text :achievements
      t.text :summary

      t.timestamps
    end
  end
end
