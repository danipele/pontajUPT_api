# frozen_string_literal: true

class DownloadReport
  class << self
    include Constants

    def call(type:, date:, project:, user:)
      workbook = Spreadsheet::Workbook.new
      worksheet = workbook.create_worksheet name: I18n.t('report.project_report.sheet_name')

      fill_report type, date.to_time.in_time_zone(LOCAL_TIMEZONE).to_date, project, worksheet, user

      workbook
    end

    private

    def fill_report(type, date, project, worksheet, user)
      case type
      when PROJECT_REPORT
        FillProjectReportExcel.call date: date,
                                    project_id: project,
                                    worksheet: worksheet,
                                    user: user
      end
    end
  end
end
