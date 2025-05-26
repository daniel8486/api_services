class ErrorsController < ApplicationController
  include JsonResponse

  def not_found
    if request.path.start_with?("/assets") || request.path.start_with?("/favicon.ico")
      head :not_found
    else
      render json: { error: "Resource not found" }, status: :not_found
    end
  end
  def internal_server_error
    render_error("Erro interno do servidor", :internal_server_error)
  end

  def unprocessable_entity
    render_error("Entidade não processável", :unprocessable_entity)
  end

  def unauthorized
    render_error("Não autorizado", :unauthorized)
  end

  def forbidden
    render_error("Acesso proibido", :forbidden)
  end
end
