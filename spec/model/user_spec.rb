require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Internet.unique.username, email: Faker::Internet.unique.email, password: 'Gaurav123') }
    let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Internet.unique.username, email: Faker::Internet.unique.email, password: 'Akshay123') }
  
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value('test@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }

    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }

    it { should validate_presence_of(:firstname) }
    it { should validate_presence_of(:lastname) }

    it { should validate_length_of(:password).is_at_least(5) }
  end

  describe "associations" do

    # it { should have_many(:ratings).dependent(:destroy) }
    it { should have_many(:comment).dependent(:destroy) }
    it { should have_many(:watchlist).dependent(:destroy) }
    it { should have_many(:watchlater).dependent(:destroy) }
  end
end
