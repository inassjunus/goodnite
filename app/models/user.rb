class User < ApplicationRecord
  has_secure_password
  has_many :clock_ins, dependent: :destroy

  has_many :active_relationships, class_name: "Following", foreign_key: "user_id", dependent: :destroy, inverse_of: :user
  has_many :followings, through: :active_relationships, source: :target
  has_many :passive_relationships, class_name: "Following", foreign_key: "target_id", dependent: :destroy, inverse_of: :target
  has_many :followers, through: :passive_relationships, source: :user

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :email, email: true
end
