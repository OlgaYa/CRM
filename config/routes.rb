Rails.application.routes.draw do

  devise_for :users, :skip => :registration

  resources :users
  resources :tasks, only:[:index, :create, :destroy, :update]
  resources :comments, only: [:create, :destroy]
  resources :sold_tasks, only: :update
  resources :meetings, only: [:index, :create]
  resources :statistics, only: :index do
    collection do
      patch :change_information
    end
  end

  root to: 'static_pages#home'
  match '/home', to: 'static_pages#home', via: 'get'
  match '/all_users', to: 'admin#all_users', via: 'get', as: 'all_users'
  
  namespace :admin do
    resources :registration
  end

end
