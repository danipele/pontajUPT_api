# frozen_string_literal: true

class FillOnlineHourlyPaymentReport
  class << self
    include Constants

    def call(date:, worksheet:, user:)
      attributes date, worksheet, user

      fill_table_headers
      fill_table_cells
    end

    private

    attr_reader :date, :user, :worksheet

    def attributes(date, worksheet, user)
      @date = date
      @worksheet = worksheet
      @user = user
    end

    def fill_table_headers
      @worksheet.row(9).concat [
        I18n.t('report.online_report.headers.nr'),
        I18n.t('report.online_report.headers.performed_activity'),
        I18n.t('report.online_report.headers.communication_materials'),
        I18n.t('report.online_report.headers.online_session'),
        I18n.t('report.online_report.headers.other_communication_ways'),
        I18n.t('report.online_report.headers.time_of_activity'),
        I18n.t('report.online_report.headers.validated_hours')
      ]
    end

    def fill_table_cells
      row = 10
      activity_idx = 1
      @user.events.where('EXTRACT(MONTH FROM start_date) = ? and type = ?', @date.month, HOURLY_PAYMENT)
           .group_by(&:activity).each do |activity, events|
        fill_activity activity, events, row, activity_idx
        row = fill_events events, row
        activity_idx += 1
      end

      row - 1
    end

    def fill_activity(activity, events, row, activity_idx)
      @worksheet.merge_cells row, 1, row + events.length - 1, 1
      @worksheet.row(row).concat [
        "#{activity_idx}.", "#{activity.course.name} / #{I18n.t("course.subactivities.#{activity.type}")}"
      ]
    end

    def fill_events(events, row)
      events.each do |event|
        descriptions = event.description.split '|'
        fill_descriptions descriptions, row
        fill_hours event, row
        row += 1
      end

      row
    end

    def fill_descriptions(descriptions, row)
      @worksheet.row(row).concat [''] unless @worksheet.rows[row]
      @worksheet.rows[row][2] = descriptions.first
      @worksheet.rows[row][3] = descriptions.second
      @worksheet.rows[row][4] = descriptions.third
    end

    def fill_hours(event, row)
      event_start_hour = event.start_date.to_time.hour
      event_end_hour = event.end_date.to_time.hour
      hours_description = "#{(event_end_hour.zero? ? 24 : event_end_hour) - event_start_hour}h / " \
                          "#{event.start_date.beginning_of_week.strftime('%d.%m')}-" \
                          "#{event.start_date.end_of_week.strftime('%d.%m.%Y')}"
      @worksheet.row(row).concat [hours_description]
    end
  end
end
