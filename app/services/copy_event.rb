# frozen_string_literal: true

class CopyEvent
  class << self
    include Constants

    def call(event_id:, start_date:, user:)
      @user = user
      event = @user.events.find event_id
      diff = event.end_date.hour.zero? ? 24 : event.end_date.hour - event.start_date.hour

      copy_event = create_copy_event event, start_date, diff

      if copy_event.activity.is_a? Holiday
        save_holiday_event copy_event
      else
        handle_copy_event copy_event, diff
      end
    end

    private

    attr_reader :user

    def handle_copy_event(copy_event, diff)
      if copy_event.type == PROJECT_TYPE
        copy_event.save!
        @user.events << copy_event
        1
      elsif weekend(copy_event)
        return 0 if copy_event.activity.is_a?(OtherActivity)

        save_course_hour_pay copy_event
      else
        handle_basic_and_hour_pay diff, copy_event
      end
    end

    def weekend(copy_event)
      copy_event.start_date.saturday? || copy_event.start_date.sunday?
    end

    def create_copy_event(event, start_date, diff)
      copy_event = event.dup
      copy_event.start_date = start_date.to_time
      end_date = start_date.to_time
      copy_event.end_date = end_date + diff.hour

      copy_event
    end

    def handle_basic_and_hour_pay(diff, copy_event)
      basic_hours = basic_hours copy_event.start_date.to_date

      if basic_hours + diff <= 8
        save_only_basic_event copy_event
      else
        handle_hour_pay basic_hours, diff, copy_event
      end
    end

    def basic_hours(date)
      date_events = @user.events.filter { |event| event.start_date.to_date == date && event.type == BASIC_NORM }

      date_events.inject(0) do |sum, event|
        sum + (event.end_date.hour.zero? ? 24 : event.end_date.hour) - event.start_date.hour
      end
    end

    def save_only_basic_event(copy_event)
      copy_event.type = BASIC_NORM
      copy_event.save!
      @user.events << copy_event
      1
    end

    def handle_hour_pay(basic_hours, diff, copy_event)
      remove = basic_hours + diff - 8

      case copy_event.activity
      when OtherActivity
        return handle_other_activity_event copy_event, remove unless basic_hours == 8

        0
      when CourseHour
        handle_course_hour_pay remove, copy_event, basic_hours, diff
      end
    end

    def handle_course_hour_pay(remove, copy_event, basic_hours, diff)
      if basic_hours == 8
        save_course_hour_pay copy_event
      else
        save_basic_event copy_event.dup, remove
        add = diff - remove
        save_hour_pay_event copy_event.dup, add
        2
      end
    end

    def save_basic_event(copy_event, remove)
      copy_event.end_date -= remove.hour
      copy_event.type = BASIC_NORM
      copy_event.save!
      @user.events << copy_event
    end

    def save_hour_pay_event(copy_event, add)
      copy_event.start_date += add.hour
      copy_event.type = HOURLY_PAYMENT
      copy_event.save!
      @user.events << copy_event
    end

    def handle_other_activity_event(copy_event, remove)
      copy_event.end_date -= remove.hour
      copy_event.type = BASIC_NORM
      copy_event.save!
      @user.events << copy_event
      1
    end

    def save_course_hour_pay(copy_event)
      return 0 unless COLLABORATOR_EVENTS.include? copy_event.activity.type

      copy_event.type = HOURLY_PAYMENT
      copy_event.save!
      @user.events << copy_event
      1
    end

    def save_holiday_event(copy_event)
      copy_event.type = HOLIDAY_TYPE
      copy_event.save!
      @user.events << copy_event
      1
    end
  end
end
