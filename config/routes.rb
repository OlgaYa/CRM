Rails.application.routes.draw do

  devise_for :users, :skip => :registration

  resources :users
  resources :tasks, only:[:index, :create, :destroy, :update]
  resources :comments, only: [:create, :destroy]
  resources :sold_tasks, only: :update
  resources :meetings, only: [:index, :create]
  resources :statistics, only: :index do
    collection do
      post :change_information
    end
  end

  root to: 'static_pages#home'
  match '/home', to: 'static_pages#home', via: 'get'
  match '/all_users', to: 'admin#all_users', via: 'get', as: 'all_users'
  match 'export', to: 'tasks#export', via: 'get', as: 'export'
  match 'export', to: 'tasks#download_xls', via: 'post'
  
  namespace :admin do
    resources :registration
  end

end
