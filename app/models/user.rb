class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :rating,dependent: :destroy
  has_many :comment,dependent: :destroy
  has_many :watchlist,dependent: :destroy
  has_many :watchlater,dependent: :destroy

  # has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :email,format: {with:URI::MailTo::EMAIL_REGEXP}
  validates :username, presence: true, uniqueness: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :password, length: {minimum: 5},
              if:lambda{new_record? || !password.nil?}

  def self.ransackable_associations(auth_object = nil)
    ["comment", "rating", "watchlater", "watchlist"]
  end
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "firstname", "id", "id_value", "lastname", "password", "twofa", "twofa_on_off", "updated_at", "username", "reset_password_token", "reset_password_sent_at", "remember_created_at"]
  end
  

end
  
