class CreateWatchlists < ActiveRecord::Migration[7.1]
  def change
    create_table :watchlists do |t|
      t.bigint :user_id
      t.string :watchlist_movie_id
      

      t.timestamps
    end
  end
end
