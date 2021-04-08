# frozen_string_literal: true

class EventResponse
  class << self
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
      when ProjectHour
        fill_project_hour response, event
      when OtherActivity
        fill_other_activity response, event
      when Holiday
        fill_holiday response, event
      end
    end

    def fill_course_hour(response, event)
      response['activity'] = 'Activitate didactica'
      response['subactivity'] = event.activity.type
      response['entity'] = Course.find_by(id: event.activity.course_id)
    end

    def fill_project_hour(response, event)
      response['activity'] = 'Proiect'
      response['subactivity'] = event.activity.type
      response['entity'] = Project.find_by(id: event.activity.project_id)
    end

    def fill_other_activity(response, event)
      response['activity'] = 'Alta activitate'
      response['subactivity'] = event.activity.name
    end

    def fill_holiday(response, event)
      response['activity'] = 'Concediu'
      response['subactivity'] = event.activity.name
    end
  end
end
