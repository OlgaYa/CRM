require 'bundler/capistrano'
require "rvm/capistrano"  # Load RVM's capistrano plugin.
require 'capistrano/ext/multistage'

set :bundle_flags,    "--deployment --quiet --local"

set :application, "crm"
set :repository, 'git@github.com:Anastasiya09/CRM.git'

set :scm, :git

set :use_sudo, false
set :rails_env, "production"


set :deploy_via, :remote_cache
set :keep_releases, 5
set :normalize_asset_timestamps, false
set(:pid) { "#{shared_path}/pids/unicorn.master.pid" }
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
end

after 'deploy:start' do
  run "cd #{release_path} && RAILS_ENV=production bundle exec unicorn_rails #{unicorn_options}"
  run "ln -nfs #{shared_path}/sockets/unicorn.sock #{release_path}/tmp/sockets/unicorn.sock"
  run "ln -nfs #{shared_path}/pids #{release_path}/tmp"
end

after "deploy:update", "deploy:cleanup"

require './config/boot'
