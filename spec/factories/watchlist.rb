# spec/factories/watchlists.rb
FactoryBot.define do
  factory :watchlist do
    # Ensure that the associated user exists before creating a watchlist
    association :user

    # Example values for other attributes
    watchlist_movie_id { 1 } # Replace with appropriate data
  end
end
