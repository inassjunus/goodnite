class User < ApplicationRecord
  has_secure_password
  has_many :clock_ins, dependent: :destroy
  has_many :followers, foreign_key: "target_id", class_name: "Following", dependent: :destroy
  has_many :followings, foreign_key: "user_id", class_name: "Following", dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
end
