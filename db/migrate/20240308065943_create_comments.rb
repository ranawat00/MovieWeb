class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.bigint :user_id
      t.string :comment_title
      t.text :comment_body
      t.string :comment_movie_id

      t.timestamps
    end
  end
end
