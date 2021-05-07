# frozen_string_literal: true

class FillOnlineBasicNormReport
  class << self
    include Constants

    def call(date:, worksheet:, user:)
      attributes date, worksheet, user

      fill_table_headers
      fill_table_cells
    end

    private

    attr_reader :date, :user, :worksheet

    def attributes(date, worksheet, user)
      @date = date
      @worksheet = worksheet
      @user = user
    end

    def fill_table_headers
      @worksheet.row(9).concat [
        I18n.t('report.online_report.headers.nr'), I18n.t('report.online_report.headers.week'), 'C', 'S', 'L', 'P',
        I18n.t('course.subactivities.evaluation'), I18n.t('report.online_report.headers.details')
      ]
    end

    def fill_table_cells
      week = 1
      end_of_week = @date.end_of_week
      loop do
        fill_week end_of_week, week
        break if end_of_week.month != @date.month || end_of_week.day == @date.end_of_month.day

        end_of_week += 7.days
        week += 1
      end

      9 + week
    end

    def fill_week(end_of_week, week)
      @worksheet.row(9 + week).concat [
        "#{week}.", "#{end_of_week.beginning_of_week.strftime('%d-%m')} - #{end_of_week.strftime('%d-%m')}"
      ]
      fill_week_content end_of_week, week
    end

    def fill_week_content(end_of_week, week)
      events = week_events end_of_week
      fill_hours events, week
    end

    def week_events(end_of_week)
      @user.events.filter do |event|
        start_date = event.start_date.to_date
        start_date.end_of_week == end_of_week && start_date.month == @date.month && event.type == BASIC_NORM &&
          event.activity.is_a?(CourseHour) && type?(event)
      end
    end

    def type?(event)
      (COLLABORATOR_EVENTS.include?(event.activity.type) || event.activity.type == EVALUATION)
    end

    def fill_hours(events, week)
      descriptions = []
      fill_activities(events, week, 2, COURSE, descriptions)
      fill_activities(events, week, 3, SEMINAR, descriptions)
      fill_activities(events, week, 4, LABORATORY, descriptions)
      fill_activities(events, week, 5, PROJECT_HOUR, descriptions)
      fill_activities(events, week, 6, EVALUATION, descriptions)
      @worksheet.rows[9 + week][7] = descriptions.join("\n")
    end

    def fill_activities(events, week, col, type, descriptions)
      @worksheet.rows[9 + week][col] = events.inject(0) do |sum, event|
        if event.activity.type == type
          descriptions << event_description(event)
          sum + event_hours(event)
        else
          sum
        end
      end
    end

    def event_hours(event)
      event_start_hour = event.start_date.to_time.hour
      event_end_hour = event.end_date.to_time.hour
      (event_end_hour.zero? ? 24 : event_end_hour) - event_start_hour
    end

    def event_description(event)
      "#{event.description.gsub('|', '/ ')}/ #{event.start_date.to_date}/ #{event.start_date.to_time.hour}.00 - " \
      "#{event.end_date.to_time.hour.zero? ? 24 : event.end_date.to_time.hour}.00"
    end
  end
end
