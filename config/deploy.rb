SSHKit.config.command_map[:rake] = "bundle exec rake"
 
lock '3.3.5'
 
set :repo_url, 'https://github.com/Anastasiya09/CRM'
set :deploy_via, :remote_cache 
set :application, "crm"
 
# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
 
# Default deploy_to directory is /var/www/my_app

set :keep_releases, 5
 
namespace :deploy do
 
# desc 'Restart application'
# 	task :restart do
# 		on roles(:app), in: :sequence, wait: 5 do
# 		# Restarts Phusion Passenger
# 		execute :touch, release_path.join('tmp/restart.txt')
# 	end
# end
 
after :publishing, :restart
 
after :restart, :clear_cache do
	on roles(:web), in: :groups, limit: 3, wait: 10 do
	# Here we can do anything such as:
	# within release_path do
	# execute :rake, 'cache:clear'
	# end
	end
end
 
end 