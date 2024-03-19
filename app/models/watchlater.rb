class Watchlater < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :watchlater_movie_id, presence: true


  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "updated_at", "user_id", "watchlater_movie_id"]
  end
end
