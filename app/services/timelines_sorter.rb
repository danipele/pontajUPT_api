# frozen_string_literal: true

class TimelinesSorter
  class << self
    def call(params:, user:)
      timelines = if params[:for] == 'day'
                    for_day params[:date], user
                  else
                    for_week params[:date], user
                  end

      timelines = sort timelines, params[:sort] if params[:sort]

      return timelines.reverse if params[:direction] == 'desc'

      timelines
    end

    private

    def for_day(date_string, user)
      date = Date.strptime date_string, '%a %b %d %Y'
      user.timelines.filter { |timeline| timeline.start_date.to_date == date }
    end

    def for_week(date_string, user)
      date = Date.strptime date_string, '%a %b %d %Y'
      user.timelines.filter do |timeline|
        timeline.start_date.to_date.at_beginning_of_week == date.at_beginning_of_week
      end
    end

    def sort(timelines, sort)
      case sort
      when 'subactivity'
        sorted_by_subactivity timelines
      when 'activity'
        sorted_by_activity timelines
      when 'date'
        sorted_by_date timelines
      end
    end

    def sorted_by_subactivity(timelines)
      timelines.sort_by! do |timeline|
        activity = timeline.activity

        case activity
        when Holiday, OtherActivity
          activity.name
        when CourseHour, ProjectHour
          activity.type
        end
      end
    end

    def sorted_by_activity(timelines)
      timelines.sort_by { |timeline| timeline.activity.display_name }
    end

    def sorted_by_date(timelines)
      timelines.sort_by(&:start_date)
    end
  end
end
