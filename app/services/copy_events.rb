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

        handle_event event, start_date, end_date, user, move
      end

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

    def create_event(event, start_date, end_date, user)
      event.activity.events.create start_date: start_date,
                                   end_date: end_date,
                                   description: event.description,
                                   user: user
    end

    def handle_event(event, start_date, end_date, user, move)
      create_event(event, start_date, end_date, user)
      event.destroy if move
      @successfully += 1
    end
  end
end
