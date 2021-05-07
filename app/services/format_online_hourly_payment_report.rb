# frozen_string_literal: true

class FormatOnlineHourlyPaymentReport
  class << self
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
      @worksheet.default_format = Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle,
                                                          text_wrap: true
      @worksheet.row(5).height = 20
      (1..6).each { |col| @worksheet.column(col).width = 30 }
    end

    def format_annex
      @worksheet.rows[0].set_format 6, right_format
    end

    def format_table
      format_table_header
      format_table_content
      format_validate_hours
    end

    def format_table_header
      (0..6).each { |col| @worksheet.rows[9].set_format col, bold_border_format }
    end

    def format_table_content
      (10..@last_row).each do |row|
        (0..6).each { |col| @worksheet.rows[row].set_format col, border_format }
      end
    end

    def format_footer
      @worksheet.rows[@last_row + 2].set_format 6, right_format
      @worksheet.rows[@last_row + 3].set_format 6, right_format
    end

    def format_validate_hours
      (9..@last_row).each { |row| @worksheet.rows[row].set_format 6, grey_format }
    end

    def right_format
      Spreadsheet::Format.new horizontal_align: :right, vertical_align: :middle
    end

    def bold_border_format
      Spreadsheet::Format.new horizontal_align: :left, vertical_align: :top, text_wrap: true, border: :thin,
                              bold: true
    end

    def border_format
      Spreadsheet::Format.new horizontal_align: :left, vertical_align: :top, border: :thin, text_wrap: true
    end

    def grey_format
      Spreadsheet::Format.new horizontal_align: :left, vertical_align: :top, border: :thin, text_wrap: true,
                              pattern: 1, pattern_fg_color: :grey
    end
  end
end
