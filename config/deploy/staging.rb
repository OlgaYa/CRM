set :branch, "staging"
set :user, "crm"
set :domain, "crmstage.sloboda-studio.com"
set :deploy_to, "/home/crm/crm_app/"
set :port, 3333

role :web, domain
role :app, domain
role :db,  domain, :primary => true

default_run_options[:shell] = '/bin/bash -l'