# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :application, "api_services"
set :repo_url, "git@github.com:daniel8486/api_services.git"

set :deploy_to, "/var/www/api_services/back_end"
set :branch, "main"
set :keep_releases, 5
set :format, :airbrussh
set :log_level, :debug

# CREDENTIALS: Arquivos que devem existir no servidor
append :linked_files, "config/database.yml", "config/master.key"

# Diretórios compartilhados
append :linked_dirs, "storage", "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Para upload de arquivos (carrierwave)
append :linked_dirs, "public/uploads"

# Configurar Ruby e environment
set :rvm_ruby, "3.3.8"

# Environment variables
set :default_env, {
  "RAILS_ENV" => "production",
  "LANG" => "en_US.UTF-8",
  "LC_ALL" => "en_US.UTF-8"
}

# PULAR ASSETS (API-only)
set :assets_roles, []

# Configuração do Unicorn
set :unicorn_config_path, -> { "#{shared_path}/config/unicorn.rb" }
set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }

# Hooks de deploy
after "deploy:updated", "deploy:migrate"
after "deploy:published", "deploy:restart"

namespace :deploy do
  desc "Run database migrations"
  task :migrate do
    on roles(:app) do
      within current_path do
        with rails_env: :production do
          execute "/usr/local/rvm/bin/rvm default do bundle exec rails db:migrate"
        end
      end
    end
  end

  desc "Start unicorn"
  task :start_unicorn do
    on roles(:app) do
      within current_path do
        execute "/usr/local/rvm/bin/rvm default do bundle exec unicorn",
                "-c", fetch(:unicorn_config_path),
                "-E", "production",
                "-D"
      end
    end
  end

  desc "Stop unicorn"
  task :stop_unicorn do
    on roles(:app) do
      execute "kill -QUIT `cat #{fetch(:unicorn_pid)}`", raise_on_non_zero_exit: false
    end
  end

  desc "Restart unicorn"
  task :restart_unicorn do
    on roles(:app) do
      execute "kill -USR2 `cat #{fetch(:unicorn_pid)}`", raise_on_non_zero_exit: false
      # Fallback para systemctl se processo não existir
      execute :sudo, :systemctl, :restart, "api_services"
    end
  end

  desc "Restart application"
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, "api_services"
      sleep 5
    end
  end

  desc "Create database"
  task :create_db do
    on roles(:app) do
      within current_path do
        with rails_env: :production do
          execute "/usr/local/rvm/bin/rvm default do bundle exec rails db:create"
        end
      end
    end
  end

  desc "Setup unicorn config"
  task :setup_unicorn do
    on roles(:app) do
      execute :mkdir, "-p", "#{shared_path}/config"
      execute :mkdir, "-p", "#{shared_path}/tmp/sockets"
      execute :mkdir, "-p", "#{shared_path}/tmp/pids"
      execute :mkdir, "-p", "#{shared_path}/log"

      unicorn_config = <<-EOF
worker_processes 2
timeout 30
working_directory "#{current_path}"
listen "#{shared_path}/tmp/sockets/unicorn.sock", :backlog => 64
pid "#{shared_path}/tmp/pids/unicorn.pid"
stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"
preload_app true

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
EOF

      upload! StringIO.new(unicorn_config), "#{shared_path}/config/unicorn.rb"
    end
  end
end

# Tarefas extras para primeiro deploy
namespace :setup do
  desc "Setup initial deploy"
  task :first_deploy do
    invoke "deploy:setup_unicorn"
    invoke "deploy"
    invoke "deploy:create_db"
    invoke "deploy:migrate"
  end
end
