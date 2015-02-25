# rails_env = ENV['RAILS_ENV'] || 'development'

# 8 workers and 1 master
# worker_processes (rails_env == 'staging' || rails_env == 'production' ? 8 : 2)
# logger Logger.new($stdout) if rails_env == 'development'
# if rails_env == 'staging' || rails_env == 'production'
#   stderr_path '/home/crmuser/crmuser_app/shared/log/unicorn.mp.err.log'
#   stderr_path '/home/crmuser/crmuser_app/shared/log/unicorn.mp.out.log'
#   pid_path =  '/home/crmuser/crmuser_app/pids/unicorn.master.pid'
#   pid         '/home/crmuser/crmuser_app/shared/pids/unicorn.master.pid'
#   listen      '/home/crmuser/crmuser_app/shared/sockets/unicorn.sock';
#   working_directory '/home/crmuser/crmuser_app/current'
# # else
# #   current_path = File.expand_path(File.dirname(__FILE__))
# #   pid_path = current_path + '/../tmp/pids/unicorn_master.pid'
# #   pid current_path + '/../tmp/pids/unicorn_master.pid'
# #   listen current_path + '/../tmp/unicorn.sock'
# # end
# # Preload into master process
# # for super-fast worker spawn times
# preload_app true

# # Restart any workers that haven't responded in 30 seconds
# timeout 960

# before_fork do |server, worker|
#   ##
#   # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
#   # immediately start loading up a new version of itself (loaded with a new
#   # version of our app). When this new Unicorn is completely loaded
#   # it will begin spawning workers. The first worker spawned will check to
#   # see if an .oldbin pidfile exists. If so, this means we've just booted up
#   # a new Unicorn and need to tell the old one that it can now die. To do so
#   # we send it a QUIT.
#   #
#   # Using this method we get 0 downtime deploys.

#   old_pid = pid_path + '.oldbin'
#   if File.exists?(old_pid) && server.pid != old_pid
#     begin
#       Process.kill("QUIT", File.read(old_pid).to_i)
#     rescue Errno::ENOENT, Errno::ESRCH
#       # someone else did our job for us
#     end
#   end
# end

# after_fork do |server, worker|
#   ActiveRecord::Base.establish_connection
# end
user = "crmuser"
deploy_to  = "/home/crmuser/crmuser_app/"

stderr_path = "#{deploy_to}/shared/log/unicorn.stderr.log"
stdout_path = "#{deploy_to}/shared/log/unicorn.stdout.log"

pid_path =  '#{deploy_to}/shared/pids/unicorn.master.pid'
pid     =    '#{deploy_to}/shared/pids/unicorn.master.pid'
listen  =    '#{deploy_to}/shared/sockets/unicorn.sock';
working_directory ='#{deploy_to}/current'
old_pid    = pid_file + '.oldbin'

timeout 30
worker_processes 4 # Здесь тоже в зависимости от нагрузки, погодных условий и текущей фазы луны
listen socket_file, :backlog => 1024
pid pid_file
stderr_path err_log
stdout_path log_file

preload_app true # Мастер процесс загружает приложение, перед тем, как плодить рабочие процессы.

before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = pid_path + '.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end