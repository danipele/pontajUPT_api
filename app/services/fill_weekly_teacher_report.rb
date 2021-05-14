# frozen_string_literal: true

class FillWeeklyTeacherReport
  class << self
    include Constants

    def call(params:, workbook:)
      attributes params, workbook

      create_worksheets
    end

    private

    attr_reader :date, :user, :workbook

    def attributes(params, workbook)
      @date = params[:date]
      @workbook = workbook
      @user = params[:user]
    end

    def create_worksheets
      end_of_week = @date.end_of_week
      week = 1
      loop do
        week_worksheet end_of_week, week
        break if end_of_week.month != @date.month || end_of_week.day == @date.end_of_month.day

        end_of_week += 7.days
        week += 1
      end
    end

    def week_worksheet(end_of_week, week)
      worksheet = @workbook.create_worksheet name: I18n.t('report.teacher_report.weekly_worksheet_name', week: week)
      fill_worksheet worksheet, end_of_week
    end

    def fill_worksheet(worksheet, end_of_week)
      worksheet_format worksheet
      fill_headers worksheet
      fill_date worksheet
      fill_title worksheet
      fill_table worksheet, end_of_week
    end

    def worksheet_format(worksheet)
      worksheet.default_format = SIMPLE_FORMAT

      worksheet.row(3).height = 25
      worksheet.column(0).width = 40
      worksheet.column(9).width = 25
    end

    def fill_headers(worksheet)
      fill_university worksheet
      fill_department worksheet
    end

    def fill_university(worksheet)
      worksheet.row(0).concat [I18n.t('report.university_name')]
      worksheet.row(0).default_format = LEFT_ALIGN_FORMAT
    end

    def fill_department(worksheet)
      worksheet.row(1).concat [I18n.t('report.department', department: @user.department)]
      worksheet.row(1).default_format = LEFT_ALIGN_FORMAT
    end

    def fill_title(worksheet)
      worksheet.merge_cells 3, 0, 3, 9
      worksheet.row(3).concat [I18n.t('report.teacher_report.weekly_title')]
    end

    def fill_date(worksheet)
      worksheet.merge_cells 4, 0, 4, 9
      worksheet.row(4).concat ["#{I18n.l(@date, format: '%B')} #{@date.year}"]
    end

    def fill_table(worksheet, end_of_week)
      fill_table_header worksheet, end_of_week

      events = week_events(end_of_week) || []
      start_hour = min_start_hour(events) || 8
      end_hour = max_end_hour(events) || 22
      min_start_hour = start_hour > 8 ? 8 : start_hour
      max_end_hour = end_hour < 22 ? 22 : end_hour

      fill_table_content events, min_start_hour, max_end_hour, end_of_week, worksheet
      worksheet.rows[8][0] = "#{@user.first_name} #{@user.last_name}"
      FormatWeeklyTeacherWorksheet.call worksheet: worksheet, total_hours_row: 8 + max_end_hour - min_start_hour
    end

    def fill_table_header(worksheet, end_of_week)
      fill_table_header_info worksheet
      fill_table_header_days worksheet, end_of_week
    end

    def fill_table_header_info(worksheet)
      merge_table_header_info worksheet

      worksheet.row(6).concat [
        I18n.t('report.teacher_report.header.teacher_name'),
        I18n.t('report.teacher_report.header.working_schedule'),
        I18n.t('report.teacher_report.header.performed_activities')
      ]
      worksheet.rows[6][9] = I18n.t('report.teacher_report.header.teacher_signature')
    end

    def merge_table_header_info(worksheet)
      worksheet.merge_cells 6, 0, 7, 0
      worksheet.merge_cells 6, 1, 7, 1
      worksheet.merge_cells 6, 2, 6, 8
      worksheet.merge_cells 6, 9, 7, 9
    end

    def fill_table_header_days(worksheet, end_of_week)
      worksheet.row(7).concat ['', '', (0..6).map do |diff|
        date = end_of_week - diff.days
        "#{date.day} #{I18n.l(date, format: '%b')}"
      end.reverse].flatten
    end

    def week_events(end_of_week)
      @user.events.filter do |event|
        start_date = event.start_date.to_date
        start_date.end_of_week == end_of_week && start_date.month == @date.month &&
          (event.type == BASIC_NORM || @user.type == COLLABORATOR_TYPE)
      end
    end

    def min_start_hour(events)
      events.map do |event|
        event.type == HOLIDAY_TYPE ? 8 : event.start_date.to_time.hour
      end.min
    end

    def max_end_hour(events)
      events.map do |event|
        end_hour = event.type == HOLIDAY_TYPE ? 22 : event.end_date.to_time.hour
        end_hour.zero? ? 24 : end_hour
      end.max
    end

    def fill_table_content(events, start_hour, end_hour, end_of_week, worksheet)
      merge_content_cells worksheet, end_hour - start_hour
      fill_schedule_hours worksheet, start_hour, end_hour
      fill_hours worksheet, events, start_hour, end_of_week
      fill_total_hours worksheet, start_hour, end_hour
    end

    def merge_content_cells(worksheet, diff)
      worksheet.merge_cells 8, 0, 7 + diff, 0
      worksheet.merge_cells 8, 9, 7 + diff, 9
    end

    def fill_schedule_hours(worksheet, start_hour, end_hour)
      (0...end_hour - start_hour).each do |idx|
        hour = start_hour + idx
        worksheet.row(8 + idx).concat ['', "#{hour}-#{hour + 1}"]
      end
    end

    def fill_hours(worksheet, events, start_hour, end_of_week)
      events.each do |event|
        day_diff = calc_day_diff event, end_of_week
        if event.type == HOLIDAY_TYPE
          fill_holiday_event_hours worksheet, day_diff, event, start_hour
        else
          fill_other_event_hours event, worksheet, start_hour, day_diff
        end
      end
    end

    def calc_day_diff(event, end_of_week)
      if end_of_week.month == @date.month
        end_of_week.day - event.start_date.to_date.day
      else
        @date.end_of_month.day + end_of_week.day - event.start_date.to_date.day
      end
    end

    def event_hours(event, event_start_hour)
      event_end_hour = event.end_date.to_time.hour
      (event_end_hour.zero? ? 24 : event_end_hour) - event_start_hour
    end

    def fill_holiday_event_hours(worksheet, day_diff, event, start_hour)
      fill_event_hours worksheet, 16 - start_hour, 8, day_diff, event_code(event)
    end

    def fill_other_event_hours(event, worksheet, start_hour, day_diff)
      event_start_hour = event.start_date.to_time.hour
      event_hours = event_hours event, event_start_hour
      fill_event_hours worksheet, 8 + event_start_hour - start_hour, event_hours, day_diff, event_code(event)
    end

    def fill_event_hours(worksheet, start_row, rows, day_diff, event_code)
      (start_row...start_row + rows).each do |row|
        worksheet.rows[row][8 - day_diff] = event_code
      end
    end

    def event_code(event)
      EventCode.call event: event
    end

    def fill_total_hours(worksheet, start_hour, end_hour)
      total_hours_row = 8 + end_hour - start_hour
      worksheet.merge_cells total_hours_row, 0, total_hours_row, 1
      worksheet.row(total_hours_row).concat [I18n.t('report.total_working_hours')]

      fill_total_day_hours_cells worksheet, total_hours_row
      fill_total_week_hours worksheet, total_hours_row
    end

    def fill_total_day_hours_cells(worksheet, total_hours_row)
      (2..8).each do |col|
        total_hours = (8...total_hours_row).count { |row| worksheet.rows[row][col] }
        worksheet.rows[total_hours_row][col] = total_hours
      end
    end

    def fill_total_week_hours(worksheet, total_hours_row)
      worksheet.rows[total_hours_row][9] = (2..8).inject(0) { |sum, day| sum + worksheet.rows[total_hours_row][day] }
    end
  end
end
