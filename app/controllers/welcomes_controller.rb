class WelcomesController < ApplicationController
  def index
    render json: {
      message: "Welcome to the API Services backend! 🚀",
      documentation: ""
    }
  end
end
