module Api
  module V1
    class UsersController < ApplicationController

      def reset_password
        ApplicationMailer.with(email: params[:email]).mailer.deliver_later
      end

      def authenticated_user
        render json: User.first
      end
    end
  end
end
