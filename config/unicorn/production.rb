root = "/var/www/api_services/back_end/current"
working_directory root

# CORRIGIR: PID deve estar em shared para persistir entre deploys
pid "/var/www/api_services/back_end/shared/tmp/pids/unicorn.pid"

stderr_path "/var/www/api_services/back_end/shared/log/unicorn.stderr.log"
stdout_path "/var/www/api_services/back_end/shared/log/unicorn.stdout.log"

worker_processes 2
timeout 30
preload_app true

# Socket em shared
listen "/var/www/api_services/back_end/shared/tmp/sockets/unicorn.sock", backlog: 64

# Callbacks
before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
