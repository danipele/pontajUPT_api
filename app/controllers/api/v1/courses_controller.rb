module Api
  module V1
    class CoursesController < ApplicationController
      skip_before_action :authenticate_request, only: [:download_template]

      def index
        render json: Course.order('LOWER(name)')
      end

      def create
        Course.create! course_params

        render json: Course.order('LOWER(name)')
      end

      def update
        course = Course.find params[:id]
        course.update! course_params

        render json: Course.order('LOWER(name)')
      end

      def destroy
        Course.destroy params[:id]
      end

      def destroy_selected
        course_ids = params[:courses].map { |course| course[:id] }
        Course.where(id: course_ids).destroy_all
      end

      def download_template
        file = DownloadExcelTemplate.call header:     ['Nume', 'An de studiu', 'Semestru',
                                                       'Ciclu', 'Facultate', 'Descriere'],
                                          sheet_name: 'Cursuri'

        send_file file, filename: 'Cursuri.xls', type: 'text/xls'
      end

      def import_courses
        ImportFile.call path:  params[:courses_file].path,
                        model: 'Course'

        render json: Course.order('LOWER(name)')
      end

      private

      def course_params
        params.require(:course).permit :id, :name, :student_year, :semester, :cycle, :faculty, :description
      end
    end
  end
end
