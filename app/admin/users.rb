ActiveAdmin.register User do

  permit_params :firstname, :lastname, :username, :email, :password, :twofa, :twofa_on_off

end
