# frozen_string_literal: true

class FillProjectReportExcel
  class << self
    def call(date:, project_id:, worksheet:, user:)
      attributes worksheet, date, user, project_id

      worksheet_format
      fill_headers
      fill_title
      fill_date
      fill_table_header

      total_hours_row = fill_table
      fill_bottom total_hours_row
    end

    private

    attr_reader :worksheet, :end_of_month_day, :user, :date, :project

    def attributes(worksheet, date, user, project_id)
      @worksheet = worksheet
      @end_of_month_day = date.end_of_month.day
      @user = user
      @date = date
      @project = user.projects.find(project_id)
    end

    def worksheet_format
      @worksheet.default_format = Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle,
                                                          text_wrap: true

      @worksheet.column(0).width = 20
      @worksheet.column(@end_of_month_day + 1).width = 20
      (1...@end_of_month_day).each do |col|
        @worksheet.column(col).width = 7
      end
    end

    def fill_headers
      fill_university
      fill_project_title
      fill_financing_contract
    end

    def fill_university
      @worksheet.row(0).concat [I18n.t('report.university_name')]
      @worksheet.row(0).default_format = Spreadsheet::Format.new horizontal_align: :left
    end

    def fill_project_title
      @worksheet.row(1).concat ["#{I18n.t 'report.project_report.project_title'}: #{@project.name}"]
      @worksheet.row(1).default_format = Spreadsheet::Format.new horizontal_align: :left
    end

    def fill_financing_contract
      @worksheet.row(2).concat ["#{I18n.t 'report.project_report.financing_contract'}:"]
      @worksheet.row(2).default_format = Spreadsheet::Format.new horizontal_align: :left
    end

    def fill_title
      @worksheet.merge_cells 6, 0, 6, @end_of_month_day + 2
      @worksheet.row(6).concat [I18n.t('report.project_report.title')]
    end

    def fill_date
      @worksheet.merge_cells 8, 0, 8, @end_of_month_day + 2
      @worksheet.row(8).concat ["#{I18n.l(@date, format: '%B')} #{@date.year}"]
    end

    def fill_table_header
      merge_table_header_cells
      fill_table_header_cells
      format_table_header_cells
    end

    def merge_table_header_cells
      @worksheet.merge_cells 10, 0, 11, 0
      @worksheet.merge_cells 10, 1, 10, @end_of_month_day
      @worksheet.merge_cells 10, @end_of_month_day + 1, 11, @end_of_month_day + 1
    end

    def fill_table_header_cells
      @worksheet.row(10).concat ["#{@user.first_name} #{@user.last_name}", '']
      @worksheet.rows[10][@end_of_month_day + 1] = I18n.t 'report.signature'
      @worksheet.row(11).concat ['', (1..@end_of_month_day).map do |date_idx|
        "#{date_idx} #{I18n.l(@date, format: '%b')}"
      end].flatten
    end

    def format_table_header_cells
      (0..@end_of_month_day + 1).each do |col|
        format = Spreadsheet::Format.new(border: :thin, bold: true, horizontal_align: :centre, vertical_align: :middle)
        @worksheet.row(10).set_format col, format
        @worksheet.row(11).set_format col, format
      end
    end

    def fill_table
      total_hours = Array.new(@end_of_month_day, 0)
      max_events = fill_table_cells total_hours
      total_hours_row = 12 + (max_events < 4 ? 4 : max_events)
      format_weekend total_hours_row

      @worksheet.rows[12][0] = "#{@user.first_name} #{@user.last_name}" unless max_events.zero?

      fill_total_hours max_events, total_hours, total_hours_row

      total_hours_row
    end

    def handle_table_day(day, total_hours, max_events)
      day_date = @date.dup.change day: day
      project_events = @user.events.where('start_date::Date = ?', day_date).where(activity: @project)
      fill_day project_events, total_hours, day
      project_events.length > max_events ? project_events.length : max_events
    end

    def fill_table_cells(total_hours)
      max_events = 0
      (1..@end_of_month_day).each do |day|
        max_events = handle_table_day day, total_hours, max_events
      end

      max_events
    end

    def fill_day(project_events, total_hours, day)
      project_events.each_with_index do |event, index|
        @worksheet.row(12 + index).concat [''] unless @worksheet.rows[12 + index]
        fill_event event, total_hours, index, day
        format_table_cell day, 12 + index
      end
    end

    def fill_event(event, total_hours, index, day)
      end_hour = event.end_date.to_time.hour
      start_hour = event.start_date.to_time.hour

      fill_event_hours start_hour, end_hour, total_hours, index, day
    end

    def fill_event_hours(start_hour, end_hour, total_hours, index, day)
      @worksheet.rows[12 + index][day] = "#{start_hour} - #{end_hour.zero? ? 24 : end_hour}"
      total_hours[day - 1] += (end_hour.zero? ? 24 : end_hour) - start_hour
    end

    def fill_total_hours(max_events, total_hours, total_hours_row)
      @worksheet.merge_cells 12, 0, total_hours_row - 1, 0
      @worksheet.merge_cells 12, @end_of_month_day + 1, total_hours_row - 1, @end_of_month_day + 1
      @worksheet.row(total_hours_row).concat ["#{I18n.t 'report.total_working_hours'}:",
                                              total_hours, total_hours.sum].flatten
      format_table_margins total_hours_row, max_events, total_hours
    end

    def format_table_margins(total_hours_row, max_events, total_hours)
      initialize_rows total_hours_row
      format_first_column total_hours_row unless max_events.zero?
      format_last_column total_hours_row unless max_events.zero?
      format_total_hours total_hours_row, total_hours.length
    end

    def initialize_rows(end_row)
      (12...end_row).each do |row|
        next unless @worksheet.row(row) == []

        @worksheet.row(row).concat ['']
      end
    end

    def format_first_column(end_row)
      format = Spreadsheet::Format.new(border: :thin, bold: true, horizontal_align: :centre, vertical_align: :middle,
                                       color: :red)
      (12...end_row).each do |row|
        @worksheet.row(row).set_format 0, format
      end

      @worksheet.row(end_row).set_format 0, Spreadsheet::Format.new(border: :thin, bold: true, horizontal_align: :right)
    end

    def format_last_column(end_row)
      (12...end_row).each do |row|
        @worksheet.row(row).set_format @end_of_month_day + 1, Spreadsheet::Format.new(border: :thin)
      end

      @worksheet.row(end_row).set_format @end_of_month_day + 1, Spreadsheet::Format.new(border: :thin, bold: true,
                                                                                        horizontal_align: :centre,
                                                                                        vertical_align: :middle)
    end

    def format_table_cell(col, row)
      @worksheet.row(row).set_format col, Spreadsheet::Format.new(color: :red, horizontal_align: :centre,
                                                                  vertical_align: :middle)
    end

    def format_weekend(total_hours_row)
      (1..@end_of_month_day).each do |day|
        day_date = @date.dup.change day: day
        next unless day_date.saturday? || day_date.sunday?

        (12...total_hours_row).each do |row|
          format_weekend_cell row, day
        end
      end
    end

    def format_weekend_cell(row, col)
      @worksheet.row(row).set_format col, Spreadsheet::Format.new(color: :red, horizontal_align: :centre,
                                                                  vertical_align: :middle, pattern: 2,
                                                                  pattern_fg_color: :red)
    end

    def format_total_hours(row, columns)
      (1..columns).each do |col|
        @worksheet.row(row).set_format col, Spreadsheet::Format.new(border: :thin, bold: true,
                                                                    horizontal_align: :centre)
      end
    end

    def fill_bottom(total_hours_row)
      merge_bottom_cells total_hours_row
      fill_manager_cells total_hours_row
      fill_created_by_cells total_hours_row
      fill_bottom_name_cell total_hours_row
    end

    def merge_bottom_cells(total_hours_row)
      @worksheet.merge_cells total_hours_row + 2, 1, total_hours_row + 2, 4
      @worksheet.merge_cells total_hours_row + 3, 1, total_hours_row + 3, 4
      @worksheet.merge_cells total_hours_row + 2, @end_of_month_day, total_hours_row + 2, @end_of_month_day + 1
      @worksheet.merge_cells total_hours_row + 3, @end_of_month_day, total_hours_row + 3, @end_of_month_day + 1
    end

    def fill_manager_cells(total_hours_row)
      @worksheet.row(total_hours_row + 2).concat ['', "#{I18n.t 'report.project_report.project_manager'},"]
      @worksheet.row(total_hours_row + 2).set_format(1, Spreadsheet::Format.new(horizontal_align: :left))
      @worksheet.row(total_hours_row + 3).set_format(1, Spreadsheet::Format.new(horizontal_align: :left))
    end

    def fill_created_by_cells(total_hours_row)
      @worksheet.rows[total_hours_row + 2][@end_of_month_day] = "#{I18n.t 'report.project_report.drafted'},"
      @worksheet.row(total_hours_row + 2).set_format(@end_of_month_day,
                                                     Spreadsheet::Format.new(horizontal_align: :left))
    end

    def fill_bottom_name_cell(total_hours_row)
      @worksheet.row(total_hours_row + 3).concat ['']
      @worksheet.rows[total_hours_row + 3][@end_of_month_day] = "#{@user.first_name} #{@user.last_name}"
      @worksheet.row(total_hours_row + 3).set_format(@end_of_month_day,
                                                     Spreadsheet::Format.new(bold: true, color: :red))
    end
  end
end
