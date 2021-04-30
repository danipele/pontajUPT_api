# frozen_string_literal: true

class EventResponse
  class << self
    include Constants

    def call(event:)
      response = event.attributes
      fill_activity response, event
      response
    end

    private

    def fill_activity(response, event)
      case event.activity
      when CourseHour
        fill_course_hour response, event
      when Project
        fill_project response, event
      when OtherActivity
        fill_other_activity response, event
      when Holiday
        fill_holiday response, event
      end
    end

    def fill_course_hour(response, event)
      response[ACTIVITY] = COURSE_HOUR
      response[SUBACTIVITY] = event.activity.type
      response[ENTITY] = Course.find_by(id: event.activity.course_id)
    end

    def fill_project(response, event)
      response[ACTIVITY] = PROJECT
      response[ENTITY] = Project.find_by(id: event.activity.id)
    end

    def fill_other_activity(response, event)
      response[ACTIVITY] = OTHER_ACTIVITY
      response[SUBACTIVITY] = event.activity.name
    end

    def fill_holiday(response, event)
      response[ACTIVITY] = HOLIDAYS
      response[SUBACTIVITY] = event.activity.name
    end
  end
end
