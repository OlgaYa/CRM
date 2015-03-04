# # Simple Role Syntax
# # ==================
# # Supports bulk-adding hosts to roles, the primary server in each group
# # is considered to be the first unless any hosts have the primary
# # property set.  Don't declare `role :all`, it's a meta role.

# role :app, %w{deploy@example.com}
# role :web, %w{deploy@example.com}
# role :db,  %w{deploy@example.com}


# # Extended Server Syntax
# # ======================
# # This can be used to drop a more detailed server definition into the
# # server list. The second argument is a, or duck-types, Hash and is
# # used to set extended properties on the server.
# server '178.165.91.196', user: 'crmuser', roles: %w{web app db}


# # Custom SSH Options
# # ==================
# # You may pass any option but keep in mind that net/ssh understands a
# # limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
# #
# # Global options
# # --------------
# #  set :ssh_options, {
# #    keys: %w(/home/rlisowski/.ssh/id_rsa),
# #    forward_agent: false,
# #    auth_methods: %w(password)
# #  }
# #
# # And/or per server (overrides global)
# # ------------------------------------
# # server 'example.com',
# #   user: 'user_name',
# #   roles: %w{web app},
# #   ssh_options: {
# #     user: 'user_name', # overrides user setting above
# #     keys: %w(/home/user_name/.ssh/id_rsa),
# #     forward_agent: false,
# #     auth_methods: %w(publickey password)
# #     # password: 'please use keys'
# #   }
# set :branch, "master"

# set :rvm_type, :system    # :user is the default
# set :rvm_ruby_string, '2.1@crm'

# role :web, "178.165.91.196"   
# role :app, "178.165.91.196" 
# role :db, "178.165.91.196", primary: true # This is where Rails migrations will run

# set :deploy_to, "/home/crmuser/crmuser_app/"

# namespace :deploy do
#   remote_file_exists = lambda {|fn| capture("if [ -e #{fn} ]; then echo 1; fi") =~ /1/ }

#   desc "Start the application server"
#   task :start, roles: :app do
#   end

#   desc "Stop the application server"
#   task :stop, roles: :app do
#     run "kill -s QUIT `cat #{pid}`"
#   end

#   desc "Restart the application server"
#   task :restart, roles: :app do
#     if remote_file_exists.call(pid)
#       deploy.stop
#       deploy.start
#     else
#       deploy.start
#     end
#   end
# end
