# frozen_string_literal: true

module Api
  module V1
    class EventsController < ApplicationController
      def index
        events = EventsFiltering.call params: params,
                                      user: current_user

        render json: events.map { |event| EventResponse.call event: event }
      end

      def create
        event_from_fe = params[:event]
        activity = EventActivity.call activity: params[:activity],
                                      subactivity: params[:subactivity],
                                      entity: params[:entity]

        return render json: {} unless activity

        event = create_event activity, event_from_fe

        render json: EventResponse.call(event: event)
      end

      def destroy
        Event.destroy params[:id]
      end

      def update
        event = Event.find(params[:id])
        activity = EventActivity.call activity: params[:activity],
                                      subactivity: params[:subactivity],
                                      entity: params[:entity]

        return render json: {} unless activity

        update_event event, activity

        render json: EventResponse.call(event: event)
      end

      def destroy_selected
        event_ids = params[:events].map { |event| event[:id] }
        Event.where(id: event_ids).destroy_all
      end

      private

      def event_params
        params.require(:event).permit :start_date, :end_date, :activity, :subactivity, :entity, :description
      end

      def create_event(activity, event)
        activity.events.create start_date: event[:start_date],
                               end_date: event[:end_date],
                               description: event[:description],
                               user: current_user
      end

      def update_event(event, activity)
        event.update! start_date: params[:start_date],
                      end_date: params[:end_date],
                      description: params[:description],
                      activity: activity
      end
    end
  end
end
