require 'rails_helper'

RSpec.describe Watchlater, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:watchlater_movie_id) }
  end
end
