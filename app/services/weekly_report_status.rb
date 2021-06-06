# frozen_string_literal: true

class WeeklyReportStatus
  class << self
    include Constants

    def call(date:, user:)
      end_of_month_day = date.end_of_month.day
      (1..end_of_month_day).inject(0) do |sum, day|
        day_date = date.dup.change day: day
        sum + (not_complete?(user, day_date) ? 1 : 0)
      end
    end

    private

    def not_complete?(user, day_date)
      day_hours(user, day_date) < 8 && !day_date.saturday? && !day_date.sunday?
    end

    def day_hours(user, day_date)
      user.events.where('start_date::Date = ? and type = ?', day_date, BASIC_NORM).inject(0) do |sum, event|
        sum + (event.end_date.hour.zero? ? 24 : event.end_date.hour - event.start_date.hour)
      end
    end
  end
end
