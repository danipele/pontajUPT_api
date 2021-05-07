
# frozen_string_literal: true

class FillOnlineWorksheetReport
  class << self
    include Constants

    def call(date:, worksheet:, user:, type:)
      attributes date, worksheet, user, type

      fill_headers
      fill_info
      fill_table
    end

    private

    attr_reader :date, :user, :worksheet, :type

    def attributes(date, worksheet, user, type)
      @date = date
      @worksheet = worksheet
      @user = user
      @type = type
    end

    def fill_headers
      fill_university
      fill_department
      fill_annex
    end

    def fill_university
      @worksheet.row(0).concat [I18n.t('report.university_name')]
      @worksheet.row(0).default_format = Spreadsheet::Format.new horizontal_align: :left
    end

    def fill_department
      @worksheet.row(1).concat [I18n.t('report.department')]
      @worksheet.row(1).default_format = Spreadsheet::Format.new horizontal_align: :left
    end

    def fill_annex
      @worksheet.rows[0][@type == BASIC_NORM ? 7 : 6] = "#{I18n.t('report.online_report.annex')} 1A"
      @worksheet.row(1).default_format = Spreadsheet::Format.new horizontal_align: :left
    end

    def fill_info
      fill_title
      fill_period
      fill_name
    end

    def fill_title
      col = @type == BASIC_NORM ? 7 : 6
      @worksheet.merge_cells 4, 0, 4, col
      @worksheet.merge_cells 5, 0, 5, col
      @worksheet.row(4).concat [I18n.t('report.online_report.title')]
      @worksheet.row(5).concat [I18n.t('report.online_report.title_basic_norm')]
    end

    def fill_period
      @worksheet.merge_cells 6, 0, 6, (@type == BASIC_NORM ? 7 : 6)
      @worksheet.row(6).concat ["#{I18n.t 'report.period'} #{@date} - #{@date.end_of_month}"]
    end

    def fill_name
      @worksheet.merge_cells 8, 0, 8, 1
      @worksheet.merge_cells 8, 2, 8, 6 if @type == BASIC_NORM
      @worksheet.row(8).concat [I18n.t('report.online_report.name'), '', "#{@user.last_name} #{@user.first_name}"]
    end

    def fill_table
      last_row = case @type
                 when BASIC_NORM
                   FillOnlineBasicNormReport.call date: @date, worksheet: @worksheet, user: @user
                 when HOURLY_PAYMENT
                   FillOnlineHourlyPaymentReport.call date: @date, worksheet: @worksheet, user: @user
                 end

      fill_footer last_row + 2
      format_worksheet last_row
    end

    def fill_footer(row)
      merge_footer_cells row
      fill_director row
      fill_drafted row
    end

    def merge_footer_cells(row)
      @worksheet.merge_cells row, 0, row, 1
      @worksheet.merge_cells row + 1, 0, row + 1, 1
    end

    def fill_director(row)
      @worksheet.row(row).concat [I18n.t('report.online_report.department_director')]
      @worksheet.row(row + 1).concat ['']
    end

    def fill_drafted(row)
      col = @type == BASIC_NORM ? 7 : 6
      @worksheet.rows[row][col] = I18n.t('report.drafted')
      @worksheet.rows[row + 1][col] = "#{@user.last_name} #{@user.first_name}"
    end

    def format_worksheet(last_row)
      FormatOnlineWorksheetReport.call worksheet: worksheet, last_row: last_row, type: @type
    end
  end
end
