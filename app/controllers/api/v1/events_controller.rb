# frozen_string_literal: true

module Api
  module V1
    class EventsController < ApplicationController
      def index
        filter_events params
      end

      def create
        event_from_fe = params[:event]
        activity = event_activity

        return render json: {} unless activity

        create_event activity, event_from_fe
        successfully = create_recurrent_events activity unless params[:recurrent].blank?

        filter_events filter_params, successfully
      end

      def destroy
        Event.destroy params[:id]
      end

      def update
        event = Event.find(params[:id])
        activity = event_activity

        return render json: {} unless activity

        update_event event, activity

        filter_events params[:filter]
      end

      def destroy_selected
        event_ids = params[:events].map { |event| event[:id] }
        Event.where(id: event_ids).destroy_all
      end

      def copy_events
        successfully = CopyEvents.call from_date: from_date,
                                       to_date: to_date,
                                       user: current_user,
                                       period: params[:mode],
                                       move: params[:move]

        filter_events params[:filter], successfully
      end

      private

      def event_params
        params.require(:event).permit :start_date, :end_date, :activity, :subactivity, :entity, :description, :type
      end

      def create_event(activity, event)
        activity.events.create start_date: event[:start_date],
                               end_date: event[:end_date],
                               description: event[:description],
                               user: current_user,
                               type: event[:type]
      end

      def update_event(event, activity)
        event.update! start_date: params[:start_date],
                      end_date: params[:end_date],
                      description: params[:description],
                      activity: activity
      end

      def create_recurrent_events(activity)
        service_params = {
          recurrent: params[:recurrent],
          recurrent_date: params[:recurrent_date].to_time.in_time_zone('Bucharest'),
          weekends_too: params[:weekends_too],
          event: params[:event],
          activity: activity,
          user: current_user
        }
        CreateRecurrentEvents.call service_params
      end

      def event_activity
        EventActivity.call activity: params[:activity],
                           subactivity: params[:subactivity],
                           entity: params[:entity]
      end

      def filter_events(params, successfully = nil)
        events = EventsFiltering.call params: params,
                                      user: current_user

        json_events = events.map { |event| EventResponse.call event: event }
        return render json: json_events unless successfully

        render json: { events: json_events, successfully: successfully }
      end

      def filter_params
        filter_params = params[:filter]

        start = filter_params[:start_date_filter]
        filter_params[:start_date_filter] = start.to_time.in_time_zone('Bucharest').to_s unless start.blank?

        filter_params
      end

      def from_date
        params[:date].to_time.in_time_zone('Bucharest')
      end

      def to_date
        params[:copy_date].to_time.in_time_zone('Bucharest')
      end
    end
  end
end
