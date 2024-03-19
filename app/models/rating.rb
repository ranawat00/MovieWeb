class Rating < ApplicationRecord
  belongs_to :user
  
  validates :user_id, presence: true
  validates :rating_value, presence: true
  validates :rating_movie_id, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "rating_movie_id", "rating_value", "updated_at", "user_id"]
  end
end
