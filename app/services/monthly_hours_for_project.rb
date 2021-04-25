# frozen_string_literal: true

class MonthlyHoursForProject
  class << self
    def call(user:, project_id:, date:)
      project = user.projects.find project_id
      month_events = month_events user, date, project
      month_hours month_events
    end

    private

    def month_events(user, date, project)
      user.events.where(activity: project).filter do |event|
        event.start_date.month == date.month && event.start_date.year == date.year
      end
    end

    def month_hours(month_events)
      month_events.inject(0) do |sum, event|
        sum + (event.end_date.hour.zero? ? 24 : event.end_date.hour) - event.start_date.hour
      end
    end
  end
end
