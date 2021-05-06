# frozen_string_literal: true

class FormatWeeklyTeacherWorksheet
  class << self
    def call(worksheet:, total_hours_row:)
      @worksheet = worksheet
      @total_hours_row = total_hours_row

      format_header
      format_table
    end

    private

    def format_header
      @worksheet.rows[3].set_format 0, bold_format
    end

    def format_table
      format_table_header
      format_content_info
      format_hours
      format_total_hours
    end

    def format_table_header
      format_name_header
      format_schedule_header
      format_activities_header
      format_days_header
      format_signature_header
    end

    def format_name_header
      @worksheet.rows[6].set_format 0, bold_border_format
      @worksheet.rows[7].set_format 0, bold_border_format
    end

    def format_schedule_header
      @worksheet.rows[6].set_format 1, bold_border_format
      @worksheet.rows[7].set_format 1, bold_border_format
    end

    def format_activities_header
      (2..8).each { |col| @worksheet.rows[6].set_format col, bold_border_format }
    end

    def format_days_header
      (2..8).each { |col| @worksheet.rows[7].set_format col, bold_border_format }
    end

    def format_signature_header
      @worksheet.rows[6].set_format 9, bold_border_format
      @worksheet.rows[7].set_format 9, bold_border_format
    end

    def format_content_info
      (8...@total_hours_row).each do |row|
        @worksheet.rows[row].set_format 0, border_format
        @worksheet.rows[row].set_format 1, border_format
        @worksheet.rows[row].set_format 9, border_format
      end
    end

    def format_hours
      (2..8).each { |col| (8...@total_hours_row).each { |row| @worksheet.rows[row].set_format col, red_format } }
    end

    def format_total_hours
      @worksheet.rows[@total_hours_row].set_format 0, right_format
      @worksheet.rows[@total_hours_row].set_format 1, right_format
      (2..9).each { |col| @worksheet.rows[@total_hours_row].set_format col, bold_border_format }
    end

    def border_format
      Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, border: :thin, text_wrap: true
    end

    def bold_border_format
      Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, text_wrap: true, border: :thin,
                              bold: true
    end

    def bold_format
      Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, text_wrap: true, bold: true
    end

    def red_format
      Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, color: :red
    end

    def right_format
      Spreadsheet::Format.new horizontal_align: :right, vertical_align: :middle, border: :thin, bold: true
    end
  end
end
