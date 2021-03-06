Rails.application.routes.draw do
  devise_for :users, skip: :registration,
                     controllers: { sessions: 'users/sessions' }

  root to: 'static_pages#home'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  resources :tables, only: [:create, :update, :destroy, :index]
  resources :users
  resources :comments, only: [:create, :destroy]
  resources :meetings
  resources :statistics, only: :index do
    collection do
      post :change_information
    end
  end
  resources :plans
  resources :histories, only: [:index]
  resources :holidays,  only: [:index] do
    collection do
      post  :update_list_events
    end
  end
  
  namespace :admin do
    resources :registration
  end

  resources :reports do
    collection do
      get  :reports_settings
      post :update_report_settings
      get  :reports_pointer
    end
  end

  resources :projects do
    collection do
      get  :users_for_project
    end
  end

  # COMMON NAVIGATION AND ACTIONS
  get    'home',       to: 'static_pages#home'
  get    'baned_user', to: 'static_pages#baned_user' 
  get    'export',     to: 'tables#export',          as: 'export'
  
  post   'export_selective', to: 'tables#download_selective_xls'
  post   'export_scoped',    to: 'tables#download_scoped_xls'

  # ADMIN NAVIGATION
  get    'admin/task_controls', to: 'admin#task_controls', as: 'admin_task_controls'
  get    'admin/users',         to: 'admin#show_users',    as: 'admin_show_users'
  get    'admin/controls',      to: 'admin#controls',      as: 'admin_controls'

  # CRUD TABLE STATUSES / ADMIN CONTROLS
  post   'admin/statuses',   to: 'admin#create_status', as: :statuses
  delete 'admin/status/:id', to: 'admin#destroy_status', as: :status
  put    'admin/status/:id', to: 'admin#update_status'

  # CRUD TABLE SOURCES / ADMIN CONTROLS
  post   'admin/sources',    to: 'admin#create_source', as: :sources
  delete 'admin/source/:id', to: 'admin#destroy_source', as: :source
  put    'admin/source/:id', to: 'admin#update_source'

  # CRUD TABLE LEVELS / ADMIN CONTROLS
  post   'admin/levels',    to: 'admin#create_level', as: :levels
  delete 'admin/level/:id', to: 'admin#destroy_level', as: :level
  put    'admin/level/:id', to: 'admin#update_level'

  # CRUD TABLE SPECIALIZATION / ADMIN CONTROLS
  post   'admin/specializations',    to: 'admin#create_specialization', as: :specializations
  delete 'admin/specialization/:id', to: 'admin#destroy_specialization', as: :specialization
  put    'admin/specialization/:id', to: 'admin#update_specialization'

  # ADMIN CONTROLS
  put    'admin/user_status/:id', to: 'admin#update_user_status', as: :user_status
  
  # CRUD TABLE LINKS
  post   'tables/links',    to: 'tables#create_link'
  delete 'tables/link/:id', to: 'tables#destroy_link', as: :link

  # ACTIONS WITH TABLE SETTINGS
  get   'tables/table_settings', to: 'tables#table_settings'
  post  'tables/update_table_settings', to: 'tables#update_table_settings'

  # ACTION FOR CHECK DUPLICATE DATA IN TABLE
  get   'tables/check_duplicate_data', to: 'tables#check_duplicate_data'

  # ACTIONS FOR MAIN MENU DIRETIONS
  get   'admin/admin_pointer', to: 'admin#admin_pointer'

  # ACTIONS FOR SUMMARY REPORTS
  get   'summary_reports',     to: 'summary_reports#index'
  post  'summary_reports',     to: 'summary_reports#refresh_dt', as: :refresh
  
  match 'admin/email_texts/:action(/:id)' => 'admin/email_texts', via: :all

  get 'table_details/:id', to: 'tables#details', as: :table_details
  post 'table_details/:id', to: 'tables#details_update', as: :table_details_update

end
