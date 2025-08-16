FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "ユーザー#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password_digest { BCrypt::Password.create('password123') }
  end

  factory :guest_user, class: 'Guest' do
    session_token { SecureRandom.urlsafe_base64 }
  end

  factory :registered_user, class: 'Member' do
    sequence(:name) { |n| "登録ユーザー#{n}" }
    sequence(:email) { |n| "registered#{n}@example.com" }
    password { 'password123' }
  end
end