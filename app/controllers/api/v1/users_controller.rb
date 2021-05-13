# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request, only: %i[create reset_password]

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
                            last_name: params[:user][:last_name],
                            department: params[:user][:department],
                            didactic_degree: params[:user][:didactic_degree]

        render json: current_user
      end

      def add_holidays
        successfully = AddHolidaysForEmployees.call start_date: params[:start_date].to_time,
                                                    end_date: params[:end_date].to_time,
                                                    description: params[:description]

        render json: successfully
      end

      private

      def user_params
        params.require(:user).permit :email, :password, :first_name, :last_name, :type, :department,
                                     :didactic_degree
      end
    end
  end
end
