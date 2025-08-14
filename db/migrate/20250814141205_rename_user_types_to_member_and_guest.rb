class RenameUserTypesToMemberAndGuest < ActiveRecord::Migration[7.1]
  def up
    # RegisteredUser を Member に変更
    User.where(type: 'RegisteredUser').update_all(type: 'Member')
    # GuestUser を Guest に変更
    User.where(type: 'GuestUser').update_all(type: 'Guest')
  end

  def down
    # Member を RegisteredUser に戻す
    User.where(type: 'Member').update_all(type: 'RegisteredUser')
    # Guest を GuestUser に戻す
    User.where(type: 'Guest').update_all(type: 'GuestUser')
  end
end