class Watchlist < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :watchlist_movie_id, presence: true
end
