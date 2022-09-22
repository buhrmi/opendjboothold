class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  
  has_many :identities, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true
  validates :email, presence: true, uniqueness: true
end
