Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users
  ActiveAdmin.routes(self)
  namespace :api do
    namespace :v1 do
      get 'ratings/create'
      resources :users, only: [:create, :update, :show,:index, :destroy]
      resources :comments,only:[:create, :update,:show,:index,:destroy]
      resources :watchlists ,only: [:create, :update, :show,:index,:destroy]
      resources :watchlaters ,only: [:create, :update, :show,:index, :destroy]
      resources :ratings, only: [:create,:update, :show,:index, :destroy]
      post '/auth/login', to: 'authentication#login'
      put '/auth/forgot_password', to: 'authentication#forgot_password'

    end
  end
 
end
