# frozen_string_literal: true

class EventsFiltering
  class << self
    def call(params:, user:)
      attributes params
      fill_events user

      sort_events unless @sort.blank?
      filter_events
      return @events.to_a.reverse! if @direction == 'desc'

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
      courses_filter unless @course == '-1'
      projects_filter unless @project == '-1'
    end

    def fill_events(user)
      @events = !@start_date_filter.blank? || @all == 'true' ? Event.where(user_id: user.id) : events_for(user)
    end

    def events_for(user)
      if @for == 'day'
        for_day user
      else
        for_week user
      end
    end

    def for_day(user)
      date = Date.strptime @date, '%a %b %d %Y'
      user.events.filter { |event| event.start_date.to_date == date }
    end

    def for_week(user)
      date = Date.strptime @date, '%a %b %d %Y'
      user.events.filter do |event|
        event.start_date.to_date.at_beginning_of_week == date.at_beginning_of_week
      end
    end

    def sort_events
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
        'Project'
      else
        activity.name
      end
    end

    def sorted_by_activity
      @events = @events.sort_by { |event| event.activity.display_name }
    end

    def sorted_by_date
      @events = @events.sort_by(&:start_date)
    end

    def subactivity_filter
      return projects if @subactivity == 'Proiect'

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
      @events = @events.select { |event| event.activity.display_name == @activity }
    end

    def date_filter
      start_date = Date.strptime @start_date_filter, '%a %b %d %Y'
      end_date = Date.strptime @end_date_filter, '%a %b %d %Y' unless @end_date_filter.blank?
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
