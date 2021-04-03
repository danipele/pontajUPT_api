# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request, only: [:create]

      def create
        User.create! user_params

        render json: { success: true }
      end

      def authenticated_user
        render json: current_user
      end

      def reset_password
        ApplicationMailer.with(email: params[:email]).mailer.deliver_later
      end

      def update
        current_user.update first_name: params[:user][:first_name],
                            last_name: params[:user][:last_name]
      end

      private

      def user_params
        params.require(:user).permit :email, :password, :first_name, :last_name, :type
      end
    end
  end
end
