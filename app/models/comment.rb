class Comment < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :comment_title, presence: true
  validates :comment_body, presence: true
  validates :comment_movie_id, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["comment_body", "comment_movie_id", "comment_title", "created_at", "id", "id_value", "updated_at", "user_id"]
  end
end
