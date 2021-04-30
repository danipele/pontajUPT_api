# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApplicationController
      include Constants

      def index
        render json: current_user.projects.order(ORDER_COURSES_PROJECTS)
      end

      def create
        project = Project.new project_params
        project.user_id = current_user.id

        return render json: {} unless project.save

        render json: current_user.projects.order(ORDER_COURSES_PROJECTS)
      end

      def update
        project = Project.find params[:id]
        project.update! project_params

        render json: current_user.projects.order(ORDER_COURSES_PROJECTS)
      end

      def destroy
        Project.destroy params[:id]
      end

      def destroy_selected
        project_ids = params[:projects].map { |project| project[:id] }
        Project.where(id: project_ids).destroy_all
      end

      def download_template
        file = Tempfile.new.path
        template_workbook.write file

        send_file file, filename: I18n.t('project.filename'), type: XLS_TYPE
      end

      def import_projects
        rows = ImportFile.call path: params[:projects_file].path,
                               model: PROJECT_MODEL,
                               user: current_user

        render json: { success: true, projects: current_user.projects.order(ORDER_COURSES_PROJECTS), added: rows }
      rescue StandardError
        render json: { success: false, message: I18n.t('message.no_sheet', sheet_name: I18n.t('project.sheet_name')) }
      end

      def export_projects
        file = Tempfile.new.path
        filled_excel.write file

        send_file file, filename: I18n.t('project.filename'), type: XLS_TYPE
      end

      private

      def project_params
        params.require(:project).permit :id, :name, :description, :hours_per_month,
                                        :restricted_start_hour, :restricted_end_hour
      end

      def template_workbook
        CreateExcelTemplate.call header: [I18n.t('project.headers.name'),
                                          I18n.t('project.headers.hours_per_month'),
                                          I18n.t('project.headers.start_hour_restriction'),
                                          I18n.t('project.headers.end_hour_restriction'),
                                          I18n.t('project.headers.description')],
                                 sheet_name: I18n.t('project.sheet_name')
      end

      def filled_excel
        FillProjectsExcel.call workbook: template_workbook,
                               projects: params[:projects]
      end
    end
  end
end
