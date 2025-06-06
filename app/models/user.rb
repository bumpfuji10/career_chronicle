class User < ApplicationRecord
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: EMAIL_REGEX, message: "正しいメールアドレスを入力してください。" }
  validates :password, presence: true,
                      length: { minimum: 8 },
                      on: :create
  has_secure_password
end
