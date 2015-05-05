require 'bundler/capistrano'
require "rvm/capistrano"  # Load RVM's capistrano plugin.
require 'capistrano/ext/multistage'
require 'capistrano/sidekiq'

set :bundle_flags,    "--deployment --quiet --local"

set :application, "crm"
set :repository, 'git@github.com:Anastasiya09/CRM.git'

set :scm, :git

set :use_sudo, false
set :rails_env, "production"


set :deploy_via, :remote_cache
set :keep_releases, 5
set :normalize_asset_timestamps, false
set(:pid) { "#{shared_path}/pids/unicorn.pid" }
ssh_options[:forward_agent] = true

default_run_options[:shell] = '/bin/bash'
default_run_options[:pty] = true
unicorn_options = '-c config/unicorn.rb -D'

set :stages, %w(production staging)
set :default_stage, "staging"

set(:releases_path)     { File.join(deploy_to, version_dir) }
set(:current_release)      { File.join(releases_path, release_name) }
set(:release_path)      { File.join(releases_path, release_name) }

before "deploy:assets:symlink" do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"
  run "ln -nfs #{shared_path}/config/imap.yml #{release_path}/config/imap.yml"
  run "ln -nfs #{shared_path}/config/calendar.yml #{release_path}/config/calendar.yml"
  run "ln -nfs #{shared_path}/system #{release_path}/public/system"
end

after 'deploy:start' do
  run "cd #{release_path} && RAILS_ENV=production bundle exec unicorn_rails #{unicorn_options}"
  run "ln -nfs #{shared_path}/sockets/unicorn.sock #{release_path}/tmp/sockets/unicorn.sock"
  run "ln -nfs #{shared_path}/pids #{release_path}/tmp"
end

after "deploy:update", "deploy:cleanup"
after "deploy", "db:migrate"

namespace :db do

    desc "Migrate Production Database"
    task :migrate do
      puts "\n\n=== Migrating the Production Database! ===\n\n"
      run "cd #{deploy_to}/current && bundle exec rake db:migrate RAILS_ENV=production"
    end

  end


require './config/boot'
