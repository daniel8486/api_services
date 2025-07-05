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
  "LANG" => "pt_PT.utf8",
  "LC_ALL" => "pt_PT.utf8"
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
