module Api
  module V1
    class UsersController < ApplicationController
      def login
        email = params[:user][:email]
        password = params[:user][:password]

        user = User.find_by(email: email)
        unless user.present?
          return render json: { success: 'false',
                                message: 'Nu exista niciun cont cu acest email!' }
        end

        if user.encrypted_password != password
          return render json: { success: 'false',
                                message: 'Parola incorecta!' }
        end

        session[:current_user] = user
        render json: { success: 'true', type: 'admin' }
      end

      def logout
        session[:current_user] = nil
        render json: {}
      end

      def reset_password
        ApplicationMailer.with(email: params[:email]).mailer.deliver_later
      end

      def authenticated_user
        render json: User.first
      end
    end
  end
end
