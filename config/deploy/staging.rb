set :branch, "master"
set :rvm_type, :system
set :rvm_ruby_string, 'ruby-2.0.0-p576@crm_staging'
set :rvm_ruby_version, '2.0.0-p576'
set :user, "crmuser"

set :domain, "crmuser@server.sloboda-studio.com"
set :deploy_to, "/home/crmuser/crmuser_app/"
set :port, 3333
role :web, domain
role :app, domain
role :db,  domain, :primary => true

namespace :deploy do
  remote_file_exists = lambda {|fn| capture("if [ -e #{fn} ]; then echo 1; fi") =~ /1/ }

  desc "Start the application server"
  task :start, roles: :app do
    run "ln -nfs #{shared_path}/config/unicorn_staging.rb #{release_path}/config/unicorn.rb"
  end

  desc "Stop the application server"
  task :stop, roles: :app do
    run "kill -s QUIT `cat #{pid}`"
  end

  desc "Restart the application server"
  task :restart, roles: :app do
    if remote_file_exists.call(pid)
      deploy.stop
      deploy.start
    else
      deploy.start
    end
  end

  # task :migrations, roles: :app do
  #   puts "\033[31m Migrations in #{stage} is disabled \033[0m"
  # end

  # task :migrate, roles: :app do
  #   puts "\033[31m Migrations in #{stage} is disabled \033[0m"
  # end
end
