# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server. 
set :stage, :staging
set :branch, "master"
server '178.165.91.196', user: 'crmuser', roles: %w{web app db}

set :ssh_options, {
    forward_agent: false,
    auth_methods: %w(password),
    password: 'pad75tvr9',
    user: 'crmuser',
    port: 3333

}

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# namespace :deploy do

#   desc "Start the application server"
#   task :start, roles: :app do
#     run "ln -nfs #{shared_path}/config/unicorn_staging.rb #{current_release}/config/unicorn.rb"
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
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
