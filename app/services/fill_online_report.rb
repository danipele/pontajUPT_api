# frozen_string_literal: true

class FillOnlineReport
  class << self
    include Constants

    def call(params:, workbook:)
      if params[:user].type == EMPLOYEE_TYPE
        worksheet_title = workbook.create_worksheet(name: I18n.t('report.online_report.basic_norm'))
        fill_basic_norm_report params, worksheet_title
      end
      worksheet_title = workbook.create_worksheet(name: I18n.t('report.online_report.hourly_payment'))
      fill_hourly_payment_report params, worksheet_title
    end

    private

    def fill_basic_norm_report(params, worksheet)
      FillOnlineWorksheetReport.call params: params, worksheet: worksheet, type: BASIC_NORM
    end

    def fill_hourly_payment_report(params, worksheet)
      FillOnlineWorksheetReport.call params: params, worksheet: worksheet, type: HOURLY_PAYMENT
    end
  end
end
