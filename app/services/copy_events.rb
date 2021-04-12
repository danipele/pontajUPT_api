# frozen_string_literal: true

class CopyEvents
  class << self
    def call(from_date:, to_date:, user:, period:)
      events = events_from from_date, period, user

      events.each do |event|
        start_date = update_date event.start_date, to_date, from_date, period
        end_date = update_date event.end_date, to_date, from_date, period

        create_event(event, start_date, end_date, user) if user.events.in_period(start_date, end_date).empty?
      end
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
  end
end
