require_relative "boot"
require "business_time"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ApiServices
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0
    # Custom configuration for the API version
    config.x.api_version = "0.0.1"
    # Configuration i18n
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    # config.i18n.available_locales = [ :en, :'pt-BR' ]
    config.i18n.default_locale = :'pt-BR'

    # Enabled the session store for api_only application
    config.session_store :cookie_store, key: "_interslice_session"
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    config.active_job.queue_adapter = :sidekiq

     # Configuration for the application, engines, and railties goes here.
     #
     # These settings can be overridden in specific environments using the files
     # in config/environments, which are processed later.
     #
     # config.time_zone = "Central Time (US & Canada)"
     # config.eager_load_paths << Rails.root.join("extras")
     #
     Rails.application.config.middleware.use Warden::Manager do |manager|
       manager.failure_app = ->(env) {
         Rails.logger.info "Warden failure: #{env['warden.options'].inspect}"
         response_body = { error: "Unauthorized" }.to_json
         [ 401, { "Content-Type" => "application/json" }, [ response_body ] ]
       }
     end

    # Rails.application.config.middleware.use Warden::Manager do |manager|
    #    manager.failure_app = ->(env) {
    #    Rails.logger.info "Warden failure: #{env['warden.options'].inspect}"
    #    # ✅ CORREÇÃO: Body deve ser array de strings, não array de hashes
    #    response_body = { error: "Unauthorized" }.to_json
    #    [ 401, { "Content-Type" => "application/json" }, [ response_body ] ]
    #   }
    # end

    # config.after_initialize do
    #   Rails.application.routes.append do
    #     match "/404", to: "errors#not_found", via: :all
    #     match "/500", to: "errors#internal_server_error", via: :all
    #     match "/422", to: "errors#unprocessable_entity", via: :all
    #     match "/401", to: "errors#unauthorized", via: :all
    #     match "/403", to: "errors#forbidden", via: :all
    #   end
    # end
    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
