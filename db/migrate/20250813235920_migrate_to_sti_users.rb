class MigrateToStiUsers < ActiveRecord::Migration[7.1]
  def up
    # usersテーブルにSTI用のtypeカラムとsession_tokenカラムを追加
    add_column :users, :type, :string
    add_column :users, :session_token, :string
    add_index :users, :session_token, unique: true

    # 既存のユーザーをRegisteredUserとして設定（先に実行）
    User.where(type: nil).update_all(type: 'RegisteredUser')

    # name, email, password_digestをゲストユーザー用にnullableに変更
    change_column_null :users, :name, true
    change_column_null :users, :email, true
    change_column_null :users, :password_digest, true
    
    # 既存のguest_usersデータをusersテーブルに移行
    if table_exists?(:guest_users)
      execute <<-SQL
        INSERT INTO users (type, session_token, name, email, password_digest, created_at, updated_at)
        SELECT 'GuestUser', session_token, 'ゲストユーザー', NULL, NULL, created_at, updated_at
        FROM guest_users
      SQL
    end

    # resumesテーブルのguest_user_idをuser_idに移行
    if column_exists?(:resumes, :guest_user_id)
      execute <<-SQL
        UPDATE resumes r
        SET user_id = (
          SELECT u.id 
          FROM users u 
          INNER JOIN guest_users g ON g.session_token = u.session_token
          WHERE g.id = r.guest_user_id
        )
        WHERE r.guest_user_id IS NOT NULL
      SQL
    end

    # guest_user_idカラムを削除
    remove_column :resumes, :guest_user_id if column_exists?(:resumes, :guest_user_id)

    # guest_usersテーブルを削除
    drop_table :guest_users if table_exists?(:guest_users)
  end

  def down
    # guest_usersテーブルを再作成
    create_table :guest_users do |t|
      t.string :session_token, null: false
      t.timestamps
    end
    add_index :guest_users, :session_token, unique: true

    # GuestUserタイプのユーザーをguest_usersテーブルに戻す
    execute <<-SQL
      INSERT INTO guest_users (session_token, created_at, updated_at)
      SELECT session_token, created_at, updated_at
      FROM users
      WHERE type = 'GuestUser'
    SQL

    # resumesテーブルにguest_user_idカラムを再追加
    add_column :resumes, :guest_user_id, :bigint
    add_foreign_key :resumes, :guest_users

    # user_idをguest_user_idに戻す
    execute <<-SQL
      UPDATE resumes r
      SET guest_user_id = (
        SELECT g.id
        FROM guest_users g
        INNER JOIN users u ON u.session_token = g.session_token
        WHERE u.id = r.user_id AND u.type = 'GuestUser'
      ),
      user_id = NULL
      WHERE r.user_id IN (SELECT id FROM users WHERE type = 'GuestUser')
    SQL

    # GuestUserタイプのユーザーを削除
    User.where(type: 'GuestUser').destroy_all

    # name, email, password_digestを必須に戻す
    change_column_null :users, :name, false
    change_column_null :users, :email, false
    change_column_null :users, :password_digest, false

    # STI用のカラムを削除
    remove_column :users, :type
    remove_column :users, :session_token
  end
end