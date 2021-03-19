module Api
  module V1
    class ProjectsController < ApplicationController
      def show
        render json: Project.order('LOWER(name)')
      end

      def create
        Project.create! project_params
        render json: Project.order('LOWER(name)')
      end

      def project_params
        params.require(:project).permit(:name, :description)
      end
    end
  end
end
