Rails.application.routes.draw do
  devise_for :users, skip: :registration,
                     controllers: { sessions: 'users/sessions' }

  root to: 'static_pages#home'
  resources :tables, only: [:create, :update, :destroy, :index]
  # resources :users
  resources :comments, only: [:create, :destroy]
  # resources :sold_tasks, only: :update
  # resources :meetings, only: [:index, :create]
  # resources :tasks, only:[:index, :create, :destroy, :update]
  # resources :statistics, only: :index do
  #   collection do
  #     post :change_information
  #   end
  # end
  # get 'export', to: 'tasks#export', as: 'export'
  # post 'export', to: 'tasks#download_xls'
  # get 'home', to: 'static_pages#home'
  # get 'baned_user', to: 'static_pages#baned_user' 
  
  # namespace :admin do
  #   resources :registration
  # end

  # get 'admin/task_controls', to: 'admin#task_controls', as: 'admin_task_controls'
  # get 'admin/show_users', to: 'admin#show_users', as: 'admin_show_users'
  # post 'admin/create_source', to: 'admin#create_source', as: 'admin_create_source'
  # delete 'admin/destroy_source/:id', to: 'admin#destroy_source', as: 'admin_destroy_source'
  # put 'admin/update_source/:id', to: 'admin#update_source', as: 'admin_update_source'
  # post 'admin/create_status', to: 'admin#create_status', as: 'admin_create_status'
  # delete 'admin/destroy_status/:id', to: 'admin#destroy_status', as: 'admin_destroy_status'
  # put 'admin/update_status/:id', to: 'admin#update_status', as: 'admin_update_status'
  # post 'tasks/create_link', to: 'tasks#create_link', as: 'tasks_create_link'
  # delete 'tasks/destroy_link/:id', to: 'tasks#destroy_link', as: 'tasks_destroy_link'

  # put 'admin/update_user_status/:id', to: 'admin#update_user_status', as:'admin_update_user_status'
end
