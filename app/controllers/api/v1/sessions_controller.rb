module Api
  module V1
    class SessionsController < ApplicationController
      def create
        email = params[:user][:email].downcase
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

        session[:user_id] = user.id

        render json: { success: 'true', type: 'admin' }
      end

      def destroy
        session.delete :user_id

        render json: {}
      end
    end
  end
end
