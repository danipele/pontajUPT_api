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
        project = Project.find(params[:id])
        project.update! project_params
        render json: Project.order('LOWER(name)')
      end

      def destroy
        Project.destroy(params[:id])
      end

      def project_params
        params.require(:project).permit(:id, :name, :description)
      end
    end
  end
end
