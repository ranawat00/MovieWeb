require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:comment_title) }
    it { should validate_presence_of(:comment_body) }
    it { should validate_presence_of(:comment_movie_id) }
  end
end
