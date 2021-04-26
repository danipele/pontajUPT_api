# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      include Constants

      skip_before_action :authenticate_request, only: [:create]

      def create
        email = params[:session][:email].downcase
        password = params[:session][:password]

        user = User.find_by email: email
        return no_account unless user.present?
        return incorrect_password unless user.authenticate password

        success_response user
      end

      def destroy
        @current_user = nil

        render json: {}
      end

      private

      def no_account
        render json: { success: false,
                       message: NO_ACCOUNT_MESSAGE }
      end

      def incorrect_password
        render json: { success: false,
                       message: INCORRECT_PASSWORD_MESSAGE }
      end

      def success_response(user)
        auth_token = JsonWebToken.encode user_id: user.id

        render json: { success: true,
                       auth_token: auth_token,
                       user: user }
      end
    end
  end
end
