module Api
  module V1
    class UsersController < ApplicationController
      def login
        email = params[:user][:email]
        password = params[:user][:password]
        if email == 'a' && password == 'a'
          session[:current_user_email] = email
          render json: { success: 'true', type: 'admin' },
                 status: :ok
        else
          render json: { success: 'false', message: 'Incorect!' },
                 status: :ok
        end
      end

      def logout
        session[:current_user_email] = nil
        render json: {}, status: :ok
      end
    end
  end
end
