ActiveAdmin.register Rating do
  permit_params :user_id, :rating_value, :rating_movie_id
  
  index do
    selectable_column
    id_column
    column :user_id
    column :rating_value
    column :rating_movie_id
    column :created_at
    actions
  end

  filter :user_id
  filter :rating_value
  filter :rating_movie_id
  filter :created_at

  form do |f|
    f.inputs do
      f.input :user_id
      f.input :rating_value
      f.input :rating_movie_id
    end
    f.actions
  end
end
