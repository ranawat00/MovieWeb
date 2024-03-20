FactoryBot.define do
  factory :watchlater do
    # Ensure that the associated user exists before creating a watchlist
    association :user

    # Example values for other attributes
    watchlater_movie_id { 1 } # Replace with appropriate data
  end
end
