# frozen_string_literal: true

module Api
  module V1
    class CoursesController < ApplicationController
      include Constants

      def index
        render json: current_user.courses.order(ORDER_COURSES_PROJECTS)
      end

      def create
        course = Course.new course_params
        course.user_id = current_user.id

        return render json: {} unless course.save

        course.add_course_hours
        render json: current_user.courses.order(ORDER_COURSES_PROJECTS)
      end

      def update
        course = Course.find params[:id]
        course.update! course_params

        render json: current_user.courses.order(ORDER_COURSES_PROJECTS)
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

        send_file file, filename: I18n.t('course.filename'), type: XLS_TYPE
      end

      def import_courses
        rows = ImportFile.call path: params[:courses_file].path,
                               model: COURSE_MODEL,
                               user: current_user

        render json: { success: true, courses: current_user.courses.order(ORDER_COURSES_PROJECTS), added: rows }
      rescue StandardError
        render json: { success: false, message: I18n.t('message.no_sheet', sheet_name: I18n.t('course.sheet_name')) }
      end

      def export_courses
        file = Tempfile.new.path
        filled_excel.write file

        send_file file, filename: I18n.t('course.filename'), type: XLS_TYPE
      end

      private

      def course_params
        params.require(:course).permit :id, :name, :student_year, :semester, :cycle, :faculty, :description
      end

      def template_workbook
        CreateExcelTemplate.call header: [I18n.t('course.headers.name'),
                                          I18n.t('course.headers.year_of_study'),
                                          I18n.t('course.headers.semester'),
                                          I18n.t('course.headers.cycle'),
                                          I18n.t('course.headers.faculty'),
                                          I18n.t('course.headers.description')],
                                 sheet_name: I18n.t('course.sheet_name')
      end

      def filled_excel
        FillCoursesExcel.call workbook: template_workbook,
                              courses: params[:courses]
      end
    end
  end
end
