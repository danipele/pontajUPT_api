module Api
  module V1
    class UsersController < ApplicationController
      def show
        @user = User.find params[:id]
      end

      def create
        User.create! user_params

        render json: { success: true }
      end

      def authenticated_user
        render json: User.fourth
      end

      def reset_password
        ApplicationMailer.with(email: params[:email]).mailer.deliver_later
      end

      private

      def user_params
        params.require(:user).permit :email, :password, :first_name, :last_name, :type
      end
    end
  end
end
