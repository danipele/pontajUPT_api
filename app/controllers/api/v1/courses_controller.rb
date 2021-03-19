module Api
  module V1
    class CoursesController < ApplicationController
      def index
        render json: Course.order('LOWER(name)')
      end

      def create
        Course.create! course_params
        render json: Course.order('LOWER(name)')
      end

      def update
        course = Course.find(params[:id])
        course.update! course_params
        render json: Course.order('LOWER(name)')
      end

      def destroy
        Course.destroy(params[:id])
      end

      def destroy_selected
        course_ids = params[:courses].map { |course| course[:id] }
        Course.where(id: course_ids).destroy_all
      end

      def course_params
        params.require(:course).permit(:id, :name, :student_year, :semester, :faculty, :description)
      end
    end
  end
end
