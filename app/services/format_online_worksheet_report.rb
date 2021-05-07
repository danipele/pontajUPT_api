# frozen_string_literal: true

class FormatOnlineWorksheetReport
  class << self
    include Constants

    def call(worksheet:, last_row:, type:)
      @worksheet = worksheet
      @last_row = last_row

      format_header
      format_director
      format_table type
    end

    private

    attr_reader :worksheet, :last_row

    def format_header
      format_title
      format_name
    end

    def format_title
      @worksheet.rows[5].set_format 0, big_font_format
      @worksheet.rows[6].set_format 0, bold_format
    end

    def format_name
      @worksheet.rows[8].set_format 0, bold_right_format
      @worksheet.rows[8].set_format 2, bold_left_format
    end

    def format_director
      @worksheet.rows[@last_row + 2].set_format 0, left_format
      @worksheet.rows[@last_row + 3].set_format 0, left_format
    end

    def format_table(type)
      case type
      when BASIC_NORM
        FormatOnlineBasicNormReport.call worksheet: @worksheet, last_row: @last_row
      when HOURLY_PAYMENT
        FormatOnlineHourlyPaymentReport.call worksheet: @worksheet, last_row: @last_row
      end
    end

    def left_format
      Spreadsheet::Format.new horizontal_align: :left, vertical_align: :middle
    end

    def big_font_format
      Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, text_wrap: true, bold: true,
                              size: 14
    end

    def bold_format
      Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, text_wrap: true, bold: true
    end

    def bold_right_format
      Spreadsheet::Format.new horizontal_align: :right, vertical_align: :middle, text_wrap: true, bold: true
    end

    def bold_left_format
      Spreadsheet::Format.new horizontal_align: :left, vertical_align: :middle, text_wrap: true, bold: true
    end
  end
end
