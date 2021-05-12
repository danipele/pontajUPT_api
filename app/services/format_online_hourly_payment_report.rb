# frozen_string_literal: true

class FormatOnlineHourlyPaymentReport
  class << self
    include Constants

    def call(worksheet:, last_row:)
      @worksheet = worksheet
      @last_row = last_row

      worksheet_format
      format_annex
      format_table
      format_footer
    end

    private

    def worksheet_format
      @worksheet.default_format = SIMPLE_FORMAT
      @worksheet.row(5).height = 20
      (1..6).each { |col| @worksheet.column(col).width = 30 }
    end

    def format_annex
      @worksheet.rows[0].set_format 6, RIGHT_ALIGN_FORMAT
    end

    def format_table
      format_table_header
      format_table_content
      format_validate_hours
    end

    def format_table_header
      (0..6).each { |col| @worksheet.rows[9].set_format col, LEFT_TOP_BOLD_BORDER_FORMAT }
    end

    def format_table_content
      (10..@last_row).each do |row|
        (0..6).each { |col| @worksheet.rows[row].set_format col, LEFT_TOP_BORDER_FORMAT }
      end
    end

    def format_footer
      @worksheet.rows[@last_row + 2].set_format 6, RIGHT_ALIGN_FORMAT
      @worksheet.rows[@last_row + 3].set_format 6, RIGHT_ALIGN_FORMAT
    end

    def format_validate_hours
      (9..@last_row).each { |row| @worksheet.rows[row].set_format 6, GREY_FORMAT }
    end
  end
end
