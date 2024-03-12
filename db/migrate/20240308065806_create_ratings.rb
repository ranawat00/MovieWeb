class CreateRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :ratings do |t|
      t.bigint  :user_id
      t.float  :rating_value
      t.string :rating_movie_id

      t.timestamps
    end
  end
end
