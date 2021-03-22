module Api
  module V1
    class ProjectsController < ApplicationController
      skip_before_action :authenticate_request, only: [:download_template]

      def index
        render json: current_user.projects.order('LOWER(name)')
      end

      def create
        project = Project.new project_params
        project.user_id = current_user.id

        if project.save
          project.add_project_hours
          render json: current_user.projects.order('LOWER(name)')
        end
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
        file = DownloadExcelTemplate.call header:     %w[Nume Descriere],
                                          sheet_name: 'Proiecte'

        send_file file, filename: 'Proiecte.xls', type: 'text/xls'
      end

      def import_projects
        ImportFile.call path:  params[:projects_file].path,
                        model: 'Project',
                        user:  current_user

        render json: current_user.projects.order('LOWER(name)')
      end

      private

      def project_params
        params.require(:project).permit :id, :name, :description
      end
    end
  end
end
