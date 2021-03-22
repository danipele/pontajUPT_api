class ApplicationController < ActionController::API
  before_action :authenticate_request

  attr_reader :current_user

  private

  def authenticate_request
    authorization_header = request.headers['Authorization']
    return render json: { error: 'Not Authorized' }, status: :unauthorized unless authorization_header.present?

    decoded_token = JsonWebToken.decode authorization_header.split(' ').last
    return render json: { error: 'Not Authorized' }, status: :unauthorized unless decoded_token.present?

    user = User.find decoded_token[:user_id]
    return render json: { error: 'Invalid token' }, status: :not_acceptable unless user.present?

    @current_user = user
  end
end
