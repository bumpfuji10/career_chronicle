class CreateGuestUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :guest_users do |t|
      t.string :session_token, null: false

      t.timestamps
    end

    add_index :guest_users, :session_token, unique: true
  end
end
