require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:rating_value) }
    it { should validate_presence_of(:rating_movie_id) }
  end
end
