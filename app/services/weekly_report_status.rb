# frozen_string_literal: true

class WeeklyReportStatus
  class << self
    include Constants

    def call(date:, user:)
      end_of_month_day = date.end_of_month.day
      (1..end_of_month_day).inject(0) do |sum, day|
        day_date = date.dup.change day: day
        sum + 1 if user.events.where('start_date::Date = ? and type = ?', day_date, BASIC_NORM).length < 8
      end
    end
  end
end
