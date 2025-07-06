class WelcomesController < ApplicationController
  def index
    render json: {
      message: "Welcome to the API Services backend! 🚀",
      documentation: "https://api-services-docs.example.com",
      version: Rails.application.config.x.api_version,
      environment: Rails.env,

      current_time: Time.now,
      server: {
        host: request.host,
        port: request.port,
        protocol: request.protocol,
        user_agent: request.user_agent
      }
    }
  end
end
