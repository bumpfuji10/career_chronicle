class AddUserAndGuestUserToResumes < ActiveRecord::Migration[7.1]
  def change
    add_column :resumes, :user_id, :bigint, null: true
    add_column :resumes, :guest_user_id, :bigint, null: true
    
    add_index :resumes, :user_id
    add_index :resumes, :guest_user_id
    
    add_foreign_key :resumes, :users
    add_foreign_key :resumes, :guest_users
  end
end
