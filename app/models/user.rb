class User < ApplicationRecord

  has_many :rating,dependent: :destroy
  has_many :comment,dependent: :destroy
  has_many :watchlist,dependent: :destroy
  has_many :watchlater,dependent: :destroy

  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :email,format: {with:URI::MailTo::EMAIL_REGEXP}
  validates :username, presence: true, uniqueness: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :password, length: {minimum: 5},
              if:lambda{new_record? || !password.nil?}
end
  
