# frozen_string_literal: true

module Api
  module V1
    class TimelinesController < ApplicationController
      def index
        timelines = TimelinesFiltering.call params: params,
                                            user: current_user

        render json: timelines.map { |timeline| TimelineResponse.call timeline: timeline }
      end

      def create
        event = params[:timeline]
        activity = TimelineActivity.call activity: params[:activity],
                                         subactivity: params[:subactivity],
                                         entity: params[:entity]

        return render json: {} unless activity

        timeline = create_timeline activity, event

        render json: TimelineResponse.call(timeline: timeline)
      end

      def destroy
        Timeline.destroy params[:id]
      end

      def update
        timeline = Timeline.find(params[:id])
        activity = TimelineActivity.call activity: params[:activity],
                                         subactivity: params[:subactivity],
                                         entity: params[:entity]

        return render json: {} unless activity

        update_timeline timeline, activity

        render json: TimelineResponse.call(timeline: timeline)
      end

      def destroy_selected
        timeline_ids = params[:timelines].map { |timeline| timeline[:id] }
        Timeline.where(id: timeline_ids).destroy_all
      end

      private

      def timeline_params
        params.require(:timeline).permit :start_date, :end_date, :activity, :subactivity, :entity, :description
      end

      def create_timeline(activity, event)
        activity.timelines.create start_date: event[:start_date],
                                  end_date: event[:end_date],
                                  description: event[:description],
                                  user: current_user
      end

      def update_timeline(timeline, activity)
        timeline.update! start_date: params[:start_date],
                         end_date: params[:end_date],
                         description: params[:description],
                         activity: activity
      end
    end
  end
end
