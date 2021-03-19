module Api
  module V1
    class CoursesController < ApplicationController
      def show
        render json: Course.order('LOWER(name)')
      end

      def create
        Course.create! course_params
        render json: Course.order('LOWER(name)')
      end

      def course_params
        params.require(:course).permit(:name, :student_year, :semester, :faculty, :description)
      end
    end
  end
end
