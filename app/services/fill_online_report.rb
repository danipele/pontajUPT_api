# frozen_string_literal: true

class FillOnlineReport
  class << self
    include Constants

    def call(date:, workbook:, user:)
      if user.type == EMPLOYEE_TYPE
        worksheet_title = workbook.create_worksheet(name: I18n.t('report.online_report.basic_norm'))
        fill_basic_norm_report date, worksheet_title, user
      end
      worksheet_title = workbook.create_worksheet(name: I18n.t('report.online_report.hourly_payment'))
      fill_hourly_payment_report date, worksheet_title, user
    end

    private

    def fill_basic_norm_report(date, worksheet, user)
      FillOnlineWorksheetReport.call date: date, worksheet: worksheet, user: user, type: BASIC_NORM
    end

    def fill_hourly_payment_report(date, worksheet, user)
      FillOnlineWorksheetReport.call date: date, worksheet: worksheet, user: user, type: HOURLY_PAYMENT
    end
  end
end
