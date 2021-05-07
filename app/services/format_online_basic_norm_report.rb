# frozen_string_literal: true

class FormatOnlineBasicNormReport
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

    attr_reader :worksheet, :last_row

    def worksheet_format
      @worksheet.default_format = Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle,
                                                          text_wrap: true

      @worksheet.column(7).width = 80
      @worksheet.column(1).width = 13
      @worksheet.row(5).height = 20
      @worksheet.row(9).height = 70
      (2..6).each { |col| @worksheet.column(col).width = 5 }
    end

    def format_annex
      @worksheet.rows[0].set_format 7, right_format
    end

    def format_table
      format_table_header
      format_table_content
    end

    def format_footer
      @worksheet.rows[@last_row + 2].set_format 7, right_format
      @worksheet.rows[@last_row + 3].set_format 7, right_format
    end

    def format_table_header
      @worksheet.rows[9].set_format 0, bold_border_format
      @worksheet.rows[9].set_format 1, bold_border_format
      fill_rotate_headers
      @worksheet.rows[9].set_format 7, bold_border_format
    end

    def fill_rotate_headers
      (2..6).each { |col| @worksheet.rows[9].set_format col, rotate_format }
    end

    def format_table_content
      (10..@last_row).each do |row|
        (0..6).each { |col| @worksheet.rows[row].set_format col, border_format }
        @worksheet.rows[row].set_format 7, border_left_format
      end
    end

    def right_format
      Spreadsheet::Format.new horizontal_align: :right, vertical_align: :middle
    end

    def bold_border_format
      Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :top, text_wrap: true, border: :thin,
                              bold: true
    end

    def rotate_format
      Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, text_wrap: true, border: :thin,
                              bold: true, rotation: 90
    end

    def border_format
      Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :top, border: :thin, text_wrap: true
    end

    def border_left_format
      Spreadsheet::Format.new horizontal_align: :left, vertical_align: :middle, border: :thin, text_wrap: true
    end
  end
end

