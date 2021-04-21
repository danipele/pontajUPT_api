# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApplicationController
      def index
        render json: current_user.projects.order('LOWER(name)')
      end

      def create
        project = Project.new project_params
        project.user_id = current_user.id

        return render json: {} unless project.save

        render json: current_user.projects.order('LOWER(name)')
      end

      def update
        project = Project.find params[:id]
        project.update! project_params

        render json: current_user.projects.order('LOWER(name)')
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

        send_file file, filename: 'Proiecte.xls', type: 'text/xls'
      end

      def import_projects
        rows = ImportFile.call path: params[:projects_file].path,
                               model: 'Project',
                               user: current_user

        render json: { projects: current_user.projects.order('LOWER(name)'), added: rows }
      end

      def export_projects
        file = Tempfile.new.path
        filled_excel.write file

        send_file file, filename: 'Proiecte.xls', type: 'text/xls'
      end

      private

      def project_params
        params.require(:project).permit :id, :name, :description, :hours_per_month,
                                        :restricted_start_hour, :restricted_end_hour
      end

      def template_workbook
        CreateExcelTemplate.call header: ['Nume', 'Ore pe luna', 'Restrictie ora de inceput',
                                          'Restrictie ora de sfarsit', 'Descriere'],
                                 sheet_name: 'Proiecte'
      end

      def filled_excel
        FillProjectsExcel.call workbook: template_workbook,
                               projects: params[:projects]
      end
    end
  end
end
