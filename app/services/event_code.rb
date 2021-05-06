# frozen_string_literal: true

class EventCode
  class << self
    include Constants

    def call(event:)
      @event = event

      case @event.activity
      when Holiday
        holiday_code
      when CourseHour
        course_hour_code
      when OtherActivity
        other_activity_code
      else
        NO_CODE
      end
    end

    private

    attr_reader :event

    def holiday_code
      case @event.activity.name
      when VACATION
        VACATION_CODE
      when SICK_LEAVE
        SICK_LEAVE_CODE
      when UNPAID_LEAVE
        UNPAID_LEAVE_CODE
      when CHILD_GROWTH_LEAVE
        CHILD_GROWTH_LEAVE_CODE
      when MATERNITY_LEAVE
        MATERNITY_LEAVE_CODE
      when UNMOTIVATED_ABSENCES
        UNMOTIVATED_ABSENCES_CODE
      else
        NO_CODE
      end
    end

    def course_hour_code
      case @event.activity.type
      when COURSE
        COURSE_CODE
      when SEMINAR
        SEMINAR_CODE
      when LABORATORY
        LABORATORY_CODE
      when PROJECT_HOUR
        PROJECT_HOUR_CODE
      when EVALUATION, CONSULTATIONS
        EVALUATION_CONSULTATIONS_CODE
      when TEACHING_ACTIVITY_PREPARATION
        TEACHING_ACTIVITY_PREPARATION_CODE
      else
        NO_CODE
      end
    end

    def other_activity_code
      case @event.activity.name
      when DOCTORAL_STUDENTS_GUIDANCE
        EVALUATION_CONSULTATIONS_CODE
      when OTHER_ACTIVITIES
        TEACHING_ACTIVITY_PREPARATION_CODE
      when COOPERATION_MANAGEMENT, RESEARCH_DOCUMENTATION,
        PROJECT_FINANCING_OPPORTUNITIES_DOCUMENTATION, RESEARCH_PROJECTS_ELABORATION
        RESEARCH_CODE
      when INTERNAL_DELEGATION_DAYS
        INTERNAL_DELEGATION_DAYS_CODE
      when EXTERNAL_DELEGATION_DAYS
        EXTERNAL_DELEGATION_DAYS_CODE
      else
        NO_CODE
      end
    end
  end
end
