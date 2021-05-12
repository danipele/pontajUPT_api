# frozen_string_literal: true

class FormatWeeklyTeacherWorksheet
  class << self
    include Constants

    def call(worksheet:, total_hours_row:)
      @worksheet = worksheet
      @total_hours_row = total_hours_row

      format_header
      format_table
    end

    private

    def format_header
      @worksheet.rows[3].set_format 0, CENTER_BOLD_FORMAT
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
      @worksheet.rows[6].set_format 0, BOLD_BORDER_FORMAT
      @worksheet.rows[7].set_format 0, BOLD_BORDER_FORMAT
    end

    def format_schedule_header
      @worksheet.rows[6].set_format 1, BOLD_BORDER_FORMAT
      @worksheet.rows[7].set_format 1, BOLD_BORDER_FORMAT
    end

    def format_activities_header
      (2..8).each { |col| @worksheet.rows[6].set_format col, BOLD_BORDER_FORMAT }
    end

    def format_days_header
      (2..8).each { |col| @worksheet.rows[7].set_format col, BOLD_BORDER_FORMAT }
    end

    def format_signature_header
      @worksheet.rows[6].set_format 9, BOLD_BORDER_FORMAT
      @worksheet.rows[7].set_format 9, BOLD_BORDER_FORMAT
    end

    def format_content_info
      (8...@total_hours_row).each do |row|
        @worksheet.rows[row].set_format 0, BORDER_FORMAT
        @worksheet.rows[row].set_format 1, BORDER_FORMAT
        @worksheet.rows[row].set_format 9, BORDER_FORMAT
      end
    end

    def format_hours
      (2..8).each { |col| (8...@total_hours_row).each { |row| @worksheet.rows[row].set_format col, RED_FORMAT } }
    end

    def format_total_hours
      @worksheet.rows[@total_hours_row].set_format 0, RIGHT_BORDER_BOLD_FORMAT
      @worksheet.rows[@total_hours_row].set_format 1, RIGHT_BORDER_BOLD_FORMAT
      (2..9).each { |col| @worksheet.rows[@total_hours_row].set_format col, BOLD_BORDER_FORMAT }
    end
  end
end
