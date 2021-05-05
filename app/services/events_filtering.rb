# frozen_string_literal: true

class EventsFiltering
  class << self
    include Constants

    def call(params:, user:)
      attributes params
      fill_events user
      return [] if @events.blank?

      sort_events unless @sort.blank?
      filter_events
      return @events.to_a.reverse! if @direction == DESC

      @events
    end

    private

    attr_reader :for, :date, :sort, :direction, :subactivity, :course, :project,
                :activity, :start_date_filter, :end_date_filter, :events, :all

    def attributes(params)
      @for = params[:for]
      @date = params[:date]
      @sort = params[:sort]
      @direction = params[:direction]
      filter_attributes params
    end

    def filter_attributes(params)
      @subactivity = params[:subactivity]
      @activity = params[:activity]
      @start_date_filter = params[:start_date_filter]
      @end_date_filter = params[:end_date_filter]
      @all = params[:all]
      @course = params[:course]
      @project = params[:project]
    end

    def filter_events
      subactivity_filter unless @subactivity.blank?
      activity_filter unless @activity.blank?
      date_filter unless @start_date_filter.blank?
      courses_filter unless @course.blank?
      projects_filter unless @project.blank?
    end

    def fill_events(user)
      @events = if !@start_date_filter.blank? || ActiveModel::Type::Boolean.new.cast(@all)
                  user.events.sort_by(&:start_date)
                else
                  events_for(user)
                end
    end

    def events_for(user)
      case @for
      when DAY
        for_day user
      when WEEK
        for_week user
      end
    end

    def for_day(user)
      date = @date.to_time.in_time_zone(LOCAL_TIMEZONE).to_date

      user.events.filter { |event| event.start_date.to_date == date }.sort_by(&:start_date)
    end

    def for_week(user)
      date = @date.to_time.in_time_zone(LOCAL_TIMEZONE).to_date

      user.events.filter do |event|
        event.start_date.to_date.at_beginning_of_week == date.at_beginning_of_week
      end.sort_by(&:start_date)
    end

    def sort_events
      case @sort
      when SUBACTIVITY
        sorted_by_subactivity
      when ACTIVITY
        sorted_by_activity
      when DATE
        sorted_by_date
      end
    end

    def sorted_by_subactivity
      @events = @events.sort_by do |event|
        activity = event.activity

        event_subactivity activity
      end
    end

    def event_subactivity(activity)
      case activity
      when CourseHour
        activity.type
      when Project
        PROJECT
      else
        activity.name
      end
    end

    def sorted_by_activity
      @events = @events.sort_by { |event| event.activity.name_id }
    end

    def sorted_by_date
      @events = @events.sort_by(&:start_date)
    end

    def subactivity_filter
      return projects if @subactivity == PROJECT

      @events = @events.select do |event|
        activity = event.activity

        event.activity != Project && if activity.is_a? CourseHour
                                       activity.type == @subactivity
                                     else
                                       activity.name == @subactivity
                                     end
      end
    end

    def activity_filter
      @events = @events.select { |event| event.activity.name_id == @activity }
    end

    def date_filter
      start_date = @start_date_filter.to_date
      end_date = @end_date_filter.to_date unless @end_date_filter.blank?
      @events = @events.select do |event|
        if end_date.present?
          event.start_date.to_date >= start_date && event.start_date.to_date <= end_date
        else
          event.start_date.to_date == start_date
        end
      end
    end

    def courses_filter
      @events = @events.select do |event|
        event.activity.is_a?(CourseHour) && event.activity.course&.id == @course.to_i
      end
    end

    def projects_filter
      @events = @events.select do |event|
        event.activity.is_a?(Project) && event.activity.id == @project.to_i
      end
    end

    def projects
      @events = @events.select { |event| event.activity.is_a? Project }
    end
  end
end
