set :branch, "master"
set :user, "crmuser"
set :domain, "crmuser@server.sloboda-studio.com"
set :deploy_to, "/home/crmuser/crmuser_app/"
set :port, 3333

role :web, domain
role :app, domain
role :db,  domain, :primary => true

default_run_options[:shell] = '/bin/bash'