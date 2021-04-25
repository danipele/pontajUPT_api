# frozen_string_literal: true

class AddHolidaysForEmployees
  class << self
    def call(start_date:, end_date:, description:)
      @created = 0
      while start_date <= end_date
        date = start_date.in_time_zone('Bucharest').to_date
        if date.saturday? || date.sunday?
          start_date += 1.day
          next
        end

        start_date = handle_holiday_events start_date, description
      end

      @created
    end

    private

    def handle_holiday_events(start_date, description)
      activity = Holiday.find_by_name 'Concediu de odihna'
      next_date = add_holiday_events start_date, activity, description
      @created += 1

      next_date
    end

    def remove_events_for(start_date, user)
      date = start_date.in_time_zone('Bucharest').to_date
      user.events.should_delete_for_holiday(date).destroy_all
      user.events.should_delete_holidays_for_holiday(start_date).destroy_all
    end

    def add_holiday_events(start_date, activity, description)
      event_end_date = start_date + 1.day
      User.where(type: 'Angajat').each do |user|
        remove_events_for start_date, user
        user.events.create! start_date: start_date,
                            end_date: event_end_date,
                            activity: activity,
                            description: description,
                            type: 'concediu'
      end

      event_end_date
    end
  end
end
