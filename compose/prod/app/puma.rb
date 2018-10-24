# Change to match your CPU core count
workers 2

# Min and Max threads per worker
threads 1, 6

app_dir = "$RAILS_ROOT"
shared_dir = "#{app_dir}/puma/$SERVICE_NAME"

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# TODO Need to set up production environment
# rails_env = "development"

# Set up socket location
# This form doesn't work
# bind "tcp://localhost:3000/"
bind 'tcp://0.0.0.0:$PUMA_PORT'

# Logging
# stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true
# stdout_redirect "/var/log/$SERVICE_NAME/puma.stdout.log", "/var/log/$SERVICE_NAME/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end
