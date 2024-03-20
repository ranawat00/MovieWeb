ActiveAdmin.register Watchlist do
  permit_params :user_id, :watchlist_movie_id
  
  index do
    selectable_column
    id_column
    column :user_id
    column :watchlist_movie_id
    column :created_at
    actions
  end

  filter :user_id
  filter :watchlist_movie_id
  filter :created_at

  form do |f|
    f.inputs do
      f.input :user_id
      f.input :watchlist_movie_id
    end
    f.actions
  end
end
