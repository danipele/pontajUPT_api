# frozen_string_literal: true

class TimelinesFiltering
  class << self
    def call(params:, user:)
      attributes params
      fill_timelines user

      sort_timelines unless @sort.blank?
      subactivity_filter unless @subactivity.blank?
      activity_filter unless @activity.blank?
      date_filter unless @start_date_filter.blank?
      return timelines.to_a.reverse! if @direction == 'desc'

      timelines
    end

    private

    attr_reader :for, :date, :sort, :direction, :subactivity,
                :activity, :start_date_filter, :end_date_filter, :timelines

    def attributes(params)
      @for = params[:for]
      @date = params[:date]
      @sort = params[:sort]
      @direction = params[:direction]
      @subactivity = params[:subactivity]
      @activity = params[:activity]
      @start_date_filter = params[:start_date_filter]
      @end_date_filter = params[:end_date_filter]
      @all = params[:all]
    end

    def fill_timelines(user)
      @timelines = @start_date_filter.blank? && @all == 'false' ? timelines_for(user) : Timeline.where(user_id: user.id)
    end

    def timelines_for(user)
      if @for == 'day'
        for_day user
      else
        for_week user
      end
    end

    def for_day(user)
      date = Date.strptime @date, '%a %b %d %Y'
      user.timelines.filter { |timeline| timeline.start_date.to_date == date }
    end

    def for_week(user)
      date = Date.strptime @date, '%a %b %d %Y'
      user.timelines.filter do |timeline|
        timeline.start_date.to_date.at_beginning_of_week == date.at_beginning_of_week
      end
    end

    def sort_timelines
      case @sort
      when 'subactivity'
        sorted_by_subactivity
      when 'activity'
        sorted_by_activity
      when 'date'
        sorted_by_date
      end
    end

    def sorted_by_subactivity
      @timelines = @timelines.sort_by do |timeline|
        activity = timeline.activity

        case activity
        when Holiday, OtherActivity
          activity.name
        when CourseHour, ProjectHour
          activity.type
        end
      end
    end

    def sorted_by_activity
      @timelines = @timelines.sort_by { |timeline| timeline.activity.display_name }
    end

    def sorted_by_date
      @timelines = @timelines.sort_by(&:start_date)
    end

    def subactivity_filter
      @timelines = @timelines.select do |timeline|
        activity = timeline.activity

        case activity
        when Holiday, OtherActivity
          activity.name == @subactivity
        when CourseHour, ProjectHour
          activity.type == @subactivity
        end
      end
    end

    def activity_filter
      @timelines = @timelines.select { |timeline| timeline.activity.display_name == @activity }
    end

    def date_filter
      start_date = Date.strptime @start_date_filter, '%a %b %d %Y'
      end_date = Date.strptime @end_date_filter, '%a %b %d %Y' unless @end_date_filter.blank?
      @timelines = @timelines.select do |timeline|
        if end_date.present?
          timeline.start_date.to_date >= start_date && timeline.start_date.to_date <= end_date
        else
          timeline.start_date.to_date == start_date
        end
      end
    end
  end
end
