#require 'bundler/capistrano''

SSHKit.config.command_map[:rake] = "bundle exec rake"
 
lock '3.3.5'
 
set :deploy_to, '/home/crmuser/crmuser_app/'
set :repo_url, 'https://github.com/Anastasiya09/CRM'
set :deploy_via, :remote_cache 
set :application, "crm"
set :scm, :git
set :rails_env, "production"
set :linked_files, %w{config/database.yml config/secrets.yml}
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
 
# Default deploy_to directory is /var/www/my_app

set :keep_releases, 5


 