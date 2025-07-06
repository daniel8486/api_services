root = "/var/www/api_services/back_end/current"
working_directory root

# CORRIGIR: PID deve estar em shared para persistir entre deploys
pid "#{root}/tmp/pids/unicorn.pid"

stderr_path "#{root}/log/unicorn.stderr.log"
stdout_path "#{root}/log/unicorn.stdout.log"

worker_processes 4
timeout 30
preload_app true

# Socket em shared
listen "/tmp/api_services.sock", backlog: 64

# Callbacks
before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
