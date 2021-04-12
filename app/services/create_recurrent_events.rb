# frozen_string_literal: true

class CreateRecurrentEvents
  class << self
    def call(params)
      params params

      start_date = @event[:start_date].to_time
      end_date = @event[:end_date].to_time
      create_events start_date, end_date
    end

    private

    attr_accessor :activity, :user, :add, :recurrent_date, :weekends_too, :event

    def params(params)
      @activity = params[:activity]
      @user = params[:user]
      @recurrent_date = params[:recurrent_date]
      @weekend_too = params[:weekends_too]
      @event = params[:event]
      @recurrent = params[:recurrent]
    end

    def create_events(start_date, end_date)
      case @recurrent
      when 'Anual'
        yearly_events start_date, end_date
      when 'Lunar'
        monthly_events start_date, end_date
      when 'Saptamanal'
        weekly_events start_date, end_date
      when 'Zilnic'
        daily_events start_date, end_date
      end
    end

    def yearly_events(start_date, end_date)
      loop do
        start_date += 1.year
        end_date += 1.year
        create_event start_date, end_date, @event[:description] if should_create_event? start_date, end_date
        break if start_date.year == @recurrent_date.year
      end
    end

    def monthly_events(start_date, end_date)
      loop do
        start_date += 1.month
        end_date += 1.month
        create_event start_date, end_date, @event[:description] if should_create_event? start_date, end_date
        break if start_date.year == @recurrent_date.year && start_date.month == @recurrent_date.month
      end
    end

    def weekly_events(start_date, end_date)
      loop do
        start_date += 7.day
        end_date += 7.day
        create_event start_date, end_date, @event[:description] if should_create_event? start_date, end_date
        break if start_date.year == @recurrent_date.year &&
                 start_date.month == @recurrent_date.month &&
                 start_date.day == @recurrent_date.day
      end
    end

    def daily_events(start_date, end_date)
      loop do
        start_date += 1.day
        end_date += 1.day
        create_event start_date, end_date, @event[:description] if should_create_event? start_date, end_date
        break if start_date.year == @recurrent_date.year &&
                 start_date.month == @recurrent_date.month &&
                 start_date.day == @recurrent_date.day
      end
    end

    def create_event(start_date, end_date, description)
      @activity.events.create start_date: start_date,
                              end_date: end_date,
                              description: description,
                              user: @user
    end

    def should_create_event?(start_date, end_date)
      return false if !@weekend_too && (start_date.saturday? || start_date.sunday?)

      @user.events.in_period(start_date, end_date).empty?
    end
  end
end
