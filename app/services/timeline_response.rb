# frozen_string_literal: true

class TimelineResponse
  class << self
    def call(timeline:)
      response = timeline.attributes

      fill_activity response, timeline

      response
    end

    private

    def fill_activity(response, timeline)
      case timeline.activity
      when CourseHour
        fill_course_hour response, timeline
      when ProjectHour
        fill_project_hour response, timeline
      when OtherActivity
        fill_other_activity response, timeline
      when Holiday
        fill_holiday response, timeline
      end
    end

    def fill_course_hour(response, timeline)
      response['activity'] = 'Activitate didactica'
      response['subactivity'] = timeline.activity.type
      response['entity'] = Course.find_by(id: timeline.activity.course_id)
    end

    def fill_project_hour(response, timeline)
      response['activity'] = 'Proiect'
      response['subactivity'] = timeline.activity.type
      response['entity'] = Project.find_by(id: timeline.activity.project_id)
    end

    def fill_other_activity(response, timeline)
      response['activity'] = 'Alta activitate'
      response['subactivity'] = timeline.activity.name
    end

    def fill_holiday(response, timeline)
      response['activity'] = 'Concediu'
      response['subactivity'] = timeline.activity.name
    end
  end
end
