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

# PRODUCTION CREDENTIALS (Adicionar)
# append :linked_files, "config/credentials/production.yml.enc"

# Diretórios compartilhados
append :linked_dirs, "storage", "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Para upload de arquivos (carrierwave)
append :linked_dirs, "public/uploads"

# Configurar Ruby e environment
# set :rvm_type, :user
set :rvm_ruby, "3.3.8"

# Environment variables
set :default_env, {
  "RAILS_ENV" => "production",
  "LANG" => "en_US.UTF-8",
  "LC_ALL" => "en_US.UTF-8"
}

# Assets precompile
# set :assets_roles, [ :web, :app ]
# set :normalize_asset_timestamps, false

# Restart method
# set :passenger_restart_with_touch, false

# SSH options
# set :ssh_options, {
#  forward_agent: true,
#  user: "deploy",  # ou root se usar root
#  keys: %w[~/.ssh/id_rsa],
#  auth_methods: %w[publickey]
# }

# set :unicorn_config_path, -> { "#{current_path}/config/unicorn/production.rb" }

# namespace :deploy do
#   desc "Start unicorn"
#   task :start_unicorn do
#     on roles(:app) do
#       within current_path do
#         execute '/usr/local/rvm/bin/rvm default do bundle exec unicorn -c #{fetch(:unicorn_config_path)} -E production -D'
#       end
#     end
#   end
#
#    desc "Restart application"
#    task :restart do
#
#     invoke "unicorn:stop"
#     invoke "unicorn:start"
#    end
# end

after "deploy:finished", "deploy:restart"

namespace :deploy do
  desc "Verify that the application is running"
  task :verify do
    on roles(:app) do
      execute :sudo, :systemctl, :status, "api_services"
    end
  end

  desc "Stop Application"
  task :stop do
    on roles(:app) do
      execute :sudo, :systemctl, :stop, "api_services"
    end
  end

  desc "Restart Application"
  task :start do
    on roles(:app) do
      execute :sudo, :systemctl, :start, "api_services"
    end
  end

  desc "Restart Application"
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, "api_services"
    end
  end

# ADICIONAR ESTAS TASKS ÚTEIS:
desc "Force database seed (ignore existing data)"
task :force_seed do
  on roles(:app) do
    within current_path do
      with rails_env: :production do
        info "🚀 Force seeding database..."
        execute :bundle, :exec, :rake, "db:seed"

        # Verificar resultado
        result = capture(:bundle, :exec, :rails, :runner, "puts User.count")
        info "✅ Seed completed! Total users: #{result.strip}"
      end
    end
  end
end

desc "Show database statistics"
  task :db_stats do
    on roles(:app) do
      within current_path do
        with rails_env: :production do
          users = capture(:bundle, :exec, :rails, :runner, "puts User.count")
          degree_dependents = capture(:bundle, :exec, :rails, :runner, "puts DegreeDependent.count")
          type_documents = capture(:bundle, :exec, :rails, :runner, "puts TypeDocument.count")

          info "📊 Database Statistics:"
          info "   Users: #{users.strip}"
          info "   DegreeDependent: #{degree_dependents.strip}"
          info "   TypeDocument: #{type_documents.strip}"
        end
      end
    end
  end

 desc "Seed database only if empty"
  task :seed_if_empty do
    on roles(:app) do
      within current_path do
        with rails_env: :production do
          # Verificar quantidade de usuários
          result = capture(:bundle, :exec, :rails, :runner, "puts User.count")
          user_count = result.strip.to_i

          info "📊 Found #{user_count} users in database"

          if user_count == 0
            info "🌱 Database is empty, running seed..."
            execute :bundle, :exec, :rake, "db:seed"

            # Verificar resultado
            new_result = capture(:bundle, :exec, :rails, :runner, "puts User.count")
            info "✅ Seed completed! Users created: #{new_result.strip}"
          else
            info "⏭️  Database has #{user_count} users, skipping seed"
          end
        end
      end
    end
  end

 desc "Clear Rails cache"
  task :clear_cache do
    on roles(:app) do
      within current_path do
        with rails_env: :production do
          execute :bundle, :exec, :rake, "cache:clear"
          info "🧹 Rails cache cleared!"
        end
      end
    end
  end

  desc "Check migrations status"
   task :check_migrations do
    on roles(:app) do
      within current_path do
        with rails_env: :production do
          result = capture(:bundle, :exec, :rake, "db:migrate:status")
          info "📊 Migrations status:\n#{result}"
        end
      end
    end
  end
end
