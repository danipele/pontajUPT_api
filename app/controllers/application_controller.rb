# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Constants

  before_action :authenticate_request

  attr_reader :current_user

  private

  def authenticate_request
    authorization_header = request.headers[AUTHORIZATION_HEADER]
    return render json: { error: NOT_AUTHORIZED }, status: :unauthorized unless authorization_header.present?

    decoded_token = JsonWebToken.decode authorization_header.split(' ').last
    return render json: { error: NOT_AUTHORIZED }, status: :unauthorized unless decoded_token.present?

    begin
      user = User.find decoded_token[:user_id]
    rescue
      return render json: { error: INVALID_TOKEN }, status: :not_found
    end

    @current_user = user
  end
end
