ActiveAdmin.register User do

  permit_params :firstname, :lastname, :username, :email, :password, :twofa, :twofa_on_off
  
  index do
    selectable_column
    id_column
    column :firstname
    column :lastname
    column :username
    column :email
    column :twofa
    column :twofa_on_off
    column :created_at
    actions
  end

  filter :firstname
  filter :lastname
  filter :username
  filter :email
  filter :twofa
  filter :twofa_on_off
  filter :created_at

  form do |f|
    f.inputs do
      f.input :firstname
      f.input :lastname
      f.input :username
      f.input :email
      f.input :password
      f.input :twofa
      f.input :twofa_on_off
    end
    f.actions
  end
end
