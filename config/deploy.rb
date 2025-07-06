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

# ADICIONAR: Configuração do Unicorn
append :linked_files, "config/unicorn.rb"

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

# Configuração do Unicorn
set :unicorn_config_path, -> { "#{shared_path}/config/unicorn.rb" }
set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }

# Hooks de deploy
after "deploy:updated", "deploy:migrate"
after "deploy:migrate", "deploy:compile_assets"
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

  desc "Compile assets"
  task :compile_assets do
    on roles(:app) do
      within current_path do
        with rails_env: :production do
          execute "/usr/local/rvm/bin/rvm default do bundle exec rails assets:precompile"
        end
      end
    end
  end

  desc "Start unicorn"
  task :start_unicorn do
    on roles(:app) do
      within current_path do
        # CORRIGIDO: usar aspas simples para evitar interpolação prematura
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
      execute 'kill -QUIT `cat #{fetch(:unicorn_pid)}`', raise_on_non_zero_exit: false
    end
  end

  desc "Restart unicorn"
  task :restart_unicorn do
    on roles(:app) do
      execute 'kill -USR2 `cat #{fetch(:unicorn_pid)}`', raise_on_non_zero_exit: false
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
end
