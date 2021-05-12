# frozen_string_literal: true

class FormatOnlineBasicNormReport
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

    attr_reader :worksheet, :last_row

    def worksheet_format
      @worksheet.default_format = SIMPLE_FORMAT

      @worksheet.column(7).width = 80
      @worksheet.column(1).width = 13
      @worksheet.row(5).height = 20
      @worksheet.row(9).height = 70
      (2..6).each { |col| @worksheet.column(col).width = 5 }
    end

    def format_annex
      @worksheet.rows[0].set_format 7, RIGHT_ALIGN_FORMAT
    end

    def format_table
      format_table_header
      format_table_content
    end

    def format_footer
      @worksheet.rows[@last_row + 2].set_format 7, RIGHT_ALIGN_FORMAT
      @worksheet.rows[@last_row + 3].set_format 7, RIGHT_ALIGN_FORMAT
    end

    def format_table_header
      @worksheet.rows[9].set_format 0, TOP_BOLD_BORDER_FORMAT
      @worksheet.rows[9].set_format 1, TOP_BOLD_BORDER_FORMAT
      fill_rotate_headers
      @worksheet.rows[9].set_format 7, TOP_BOLD_BORDER_FORMAT
    end

    def fill_rotate_headers
      (2..6).each { |col| @worksheet.rows[9].set_format col, ROTATE_FORMAT }
    end

    def format_table_content
      (10..@last_row).each do |row|
        (0..6).each { |col| @worksheet.rows[row].set_format col, TOP_BORDER_FORMAT }
        @worksheet.rows[row].set_format 7, LEFT_BORDER_FORMAT
      end
    end
  end
end

