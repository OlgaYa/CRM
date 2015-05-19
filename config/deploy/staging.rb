set :branch, "staging"
set :user, "deployer"
set :domain, "deployer@lxc.sloboda-studio.com"
set :deploy_to, "/home/deployer/crmuser_app/"
set :port, 25002

role :web, domain
role :app, domain
role :db,  domain, :primary => true

default_run_options[:shell] = '/bin/bash -l'