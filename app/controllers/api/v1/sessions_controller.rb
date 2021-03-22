module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_request, only: [:create]

      def create
        email = params[:session][:email].downcase
        password = params[:session][:password]

        user = User.find_by email: email
        unless user.present?
          return render json: { success: false,
                                message: 'Nu exista niciun cont cu acest email!' }
        end

        unless user.authenticate password
          return render json: { success: false,
                                message: 'Parola incorecta!' }
        end

        auth_token = JsonWebToken.encode user_id: user.id

        render json: { success:    true,
                       auth_token: auth_token }
      end

      def destroy
        @current_user = nil

        render json: {}
      end
    end
  end
end
