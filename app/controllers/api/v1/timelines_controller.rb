# frozen_string_literal: true

module Api
  module V1
    class TimelinesController < ApplicationController
      def index
        render json: current_user.timelines
      end

      def for_day
        date = Date.strptime params[:date], '%a %b %d %Y'
        timelines = current_user.timelines.filter { |timeline| timeline.start_date.to_date == date }

        render json: timelines.map { |timeline| create_response(timeline) }
      end

      def for_week
        date = Date.strptime params[:date], '%a %b %d %Y'
        timelines = current_user.timelines.filter do |timeline|
          timeline.start_date.to_date.at_beginning_of_week == date.at_beginning_of_week
        end

        render json: timelines.map { |timeline| create_response(timeline) }
      end

      def create
        event = params[:timeline]
        activity = activity_for_timeline

        return render json: {} unless activity

        timeline = activity.timelines.create start_date: event[:start_date],
                                             end_date: event[:end_date],
                                             description: event[:description],
                                             user: current_user

        render json: create_response(timeline)
      end

      private

      def timeline_params
        params.require(:timeline).permit :start_date, :end_date, :activity, :subactivity, :entity, :description
      end

      def activity_for_timeline
        case params[:activity]
        when 'Activitate didactica'
          CourseHour.find_by type: params[:subactivity],
                             course_id: params[:entity]
        when 'Proiect'
          ProjectHour.find_by type: params[:subactivity],
                              project_id: params[:entity]
        when 'Alta activitate'
          OtherActivity.find_by name: params[:subactivity]
        when 'Concediu'
          Holiday.find_by name: params[:subactivity]
        end
      end

      def create_response(timeline)
        response = timeline.attributes

        if timeline.activity.instance_of? CourseHour
          response['activity'] = 'Activitate didactica'
          response['subactivity'] = timeline.activity.type
          response['entity'] = Course.find(timeline.activity.course_id)
        elsif timeline.activity.instance_of? ProjectHour
          response['activity'] = 'Proiect'
          response['subactivity'] = timeline.activity.type
          response['entity'] = Project.find(timeline.activity.project_id)
        elsif timeline.activity.instance_of? OtherActivity
          response['activity'] = 'Alta activitate'
          response['subactivity'] = timeline.activity.name
        elsif timeline.activity.instance_of? Holiday
          response['activity'] = 'Concediu'
          response['subactivity'] = timeline.activity.name
        end

        response
      end
    end
  end
end
