# frozen_string_literal: true

class CopyEvents
  class << self
    def call(from_date:, to_date:, user:, period:, move:)
      attributes from_date, user, period, move
      events = events_from

      @successfully = 0
      handle_events events, to_date

      user.events.reload
      @successfully
    end

    private

    attr_reader :from_date, :user, :period, :move

    def attributes(from_date, user, period, move)
      @from_date = from_date
      @user = user
      @period = period
      @move = move
    end

    def events_from
      case @period
      when 'daily'
        @user.events.from_date @from_date
      when 'weekly'
        @user.events.from_week @from_date
      end
    end

    def update_date(date, to_date)
      to_date += (date.day - @from_date.day).day if @period == 'weekly'

      date.change(year: to_date.year, month: to_date.month, day: to_date.day)
    end

    def handle_events(events, to_date)
      events.each do |event|
        start_date = update_date event.start_date, to_date
        end_date = update_date event.end_date, to_date
        events_in_period = @user.events.in_period(start_date, end_date)
        next if !events_in_period.empty? && (events_in_period[0].type != 'concediu' || event.type != 'proiect')

        handle_event event, start_date
      end
    end

    def handle_event(event, start_date)
      @successfully += CopyEvent.call event_id: event.id,
                                      start_date: start_date,
                                      user: @user
      event.destroy! if @move
    end
  end
end
