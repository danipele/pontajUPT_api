# frozen_string_literal: true

class CopyEvents
  class << self
    def call(from_date:, to_date:, user:, period:, move:)
      events = events_from from_date, period, user

      @successfully = 0
      events.each do |event|
        start_date = update_date event.start_date, to_date, from_date, period
        end_date = update_date event.end_date, to_date, from_date, period
        next unless user.events.in_period(start_date, end_date).empty?

        handle_event event, start_date, user, move
      end

      user.events.reload
      @successfully
    end

    private

    def events_from(from_date, period, user)
      case period
      when 'daily'
        user.events.from_date from_date
      when 'weekly'
        user.events.from_week from_date
      end
    end

    def update_date(date, to_date, from_date, period)
      to_date += (date.day - from_date.day).day if period == 'weekly'

      date.change(year: to_date.year, month: to_date.month, day: to_date.day)
    end

    def handle_event(event, start_date, user, move)
      @successfully += CopyEvent.call event_id: event.id,
                                      start_date: start_date,
                                      user: user
      event.destroy! if move
    end
  end
end
