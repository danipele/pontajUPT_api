module Api
  module V1
    class SessionsController < ApplicationController
      def create
        email = params[:user][:email].downcase
        password = params[:user][:password]

        user = User.find_by email: email
        unless user.present?
          return render json: { success: 'false',
                                message: 'Nu exista niciun cont cu acest email!' }
        end

        unless user.authenticate password
          return render json: { success: 'false',
                                message: 'Parola incorecta!' }
        end

        log_in user

        render json: { success: 'true', type: 'admin' }
      end

      def destroy
        log_out
        render json: {}
      end
    end
  end
end
