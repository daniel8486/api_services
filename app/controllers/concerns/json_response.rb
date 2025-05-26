module JsonResponse
  extend ActiveSupport::Concern

  def render_success(data = {}, status: :ok)
    render json: { success: true, data: data }, status: status
  end

  def render_error(message, status = :unprocessable_entity, code: nil)
    response = { success: false, error: { message: message } }
    response[:error][:code] = code if code
    render json: response, status: status
  end
end
