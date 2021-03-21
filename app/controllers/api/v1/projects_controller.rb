module Api
  module V1
    class ProjectsController < ApplicationController
      def index
        render json: Project.order('LOWER(name)')
      end

      def create
        Project.create! project_params

        render json: Project.order('LOWER(name)')
      end

      def update
        project = Project.find params[:id]
        project.update! project_params

        render json: Project.order('LOWER(name)')
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
        ImportFile.call path: params[:projects_file].path,
                        model: 'Project'

        render json: Project.order('LOWER(name)')
      end

      def project_params
        params.require(:project).permit :id, :name, :description
      end
    end
  end
end
