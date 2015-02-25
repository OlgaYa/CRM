Rails.application.routes.draw do

  devise_for :users, :skip => :registration
  
  resources :users
  resources :tasks, only:[:index, :create, :destroy, :update]
  resources :comments, only: [:create, :destroy]

  root to: 'static_pages#home'
  match '/home', to: 'static_pages#home', via: 'get'
  
  namespace :admin do
    resources :registration
  end

end
