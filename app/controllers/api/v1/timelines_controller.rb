module Api
  module V1
    class TimelinesController < ApplicationController
      def index
        render json: current_user.timelines
      end

      def for_day
        date = Date.strptime params[:date], '%a %b %d %Y'
        timelines = current_user.timelines.filter { |timeline| timeline.start_date.to_date == date }

        render json: timelines
      end

      def for_week
        date = Date.strptime params[:date], '%a %b %d %Y'
        timelines = current_user.timelines.filter do |timeline|
          timeline.start_date.to_date.at_beginning_of_week == date.at_beginning_of_week
        end

        render json: timelines
      end

      def create
        timeline = params[:timeline]
        activity = get_activity_for_timeline

        if activity
          activity.timelines.create start_date:  timeline[:start_date],
                                    end_date:    timeline[:end_date],
                                    description: timeline[:description],
                                    user:        current_user,
                                    all_day:     timeline[:all_day]
        end

        render json: {}
      end

      private

      def timeline_params
      params.require(:timeline).permit :start_date, :end_date, :all_day, :activity, :subactivity, :entity, :description
      end

      def get_activity_for_timeline
        case params[:activity]
        when 'Curs'
          CourseHour.find_by type:   params[:subactivity],
                             course: params[:entity]
        when 'Proiect'
          ProjectHour.find_by type:    params[:subactivity],
                              project: params[:entity]
        when 'Alta activitate'
          OtherActivity.find_by name: params[:subactivity]
        when 'Concediu'
          Holiday.find_by name: params[:subactivity]
        else
          nil
        end
      end
    end
  end
end
