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
      @worksheet.rows[5].set_format 0, BIG_FONT_FORMAT
      @worksheet.rows[6].set_format 0, CENTER_BOLD_FORMAT
    end

    def format_name
      @worksheet.rows[8].set_format 0, RIGHT_BOLD_FORMAT
      @worksheet.rows[8].set_format 2, LEFT_BOLD_FORMAT
    end

    def format_director
      @worksheet.rows[@last_row + 2].set_format 0, LEFT_ALIGN_FORMAT
      @worksheet.rows[@last_row + 3].set_format 0, LEFT_ALIGN_FORMAT
    end

    def format_table(type)
      case type
      when BASIC_NORM
        FormatOnlineBasicNormReport.call worksheet: @worksheet, last_row: @last_row
      when HOURLY_PAYMENT
        FormatOnlineHourlyPaymentReport.call worksheet: @worksheet, last_row: @last_row
      end
    end
  end
end
