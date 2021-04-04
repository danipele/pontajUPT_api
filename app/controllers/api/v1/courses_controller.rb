# frozen_string_literal: true

module Api
  module V1
    class CoursesController < ApplicationController
      def index
        render json: current_user.courses.order('LOWER(name)')
      end

      def create
        course = Course.new course_params
        course.user_id = current_user.id

        return render json: {} unless course.save

        course.add_course_hours
        render json: current_user.courses.order('LOWER(name)')
      end

      def update
        course = Course.find params[:id]
        course.update! course_params

        render json: current_user.courses.order('LOWER(name)')
      end

      def destroy
        Course.destroy params[:id]
      end

      def destroy_selected
        course_ids = params[:courses].map { |course| course[:id] }
        Course.where(id: course_ids).destroy_all
      end

      def download_template
        file = Tempfile.new.path
        template_workbook.write file

        send_file file, filename: 'Cursuri.xls', type: 'text/xls'
      end

      def import_courses
        ImportFile.call path: params[:courses_file].path,
                        model: 'Course',
                        user: current_user

        render json: current_user.courses.order('LOWER(name)')
      end

      def export_courses
        file = Tempfile.new.path
        filled_excel.write file

        send_file file, filename: 'Cursuri.xls', type: 'text/xls'
      end

      private

      def course_params
        params.require(:course).permit :id, :name, :student_year, :semester, :cycle, :faculty, :description
      end

      def template_workbook
        CreateExcelTemplate.call header: ['Nume', 'An de studiu', 'Semestru',
                                          'Ciclu(Licenta, Master, Doctorat)',
                                          'Facultate', 'Descriere'],
                                 sheet_name: 'Cursuri'
      end

      def filled_excel
        FillCoursesExcel.call workbook: template_workbook,
                              courses: params[:courses]
      end
    end
  end
end
