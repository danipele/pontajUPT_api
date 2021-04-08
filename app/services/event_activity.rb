# frozen_string_literal: true

class EventActivity
  class << self
    def call(activity:, subactivity:, entity:)
      case activity
      when 'Activitate didactica'
        course_hour subactivity, entity
      when 'Proiect'
        project entity
      when 'Alta activitate'
        other_activity subactivity
      when 'Concediu'
        holiday subactivity
      end
    end

    private

    def course_hour(subactivity, entity)
      CourseHour.find_by type: subactivity,
                         course_id: entity
    end

    def project(entity)
      Project.find_by id: entity
    end

    def other_activity(subactivity)
      OtherActivity.find_by name: subactivity
    end

    def holiday(subactivity)
      Holiday.find_by name: subactivity
    end
  end
end
