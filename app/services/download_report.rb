# frozen_string_literal: true

class DownloadReport
  class << self
    include Constants

    def call(type:, date:, project:, period:, user:)
      @workbook = Spreadsheet::Workbook.new
      @worksheet = @workbook.create_worksheet name: I18n.t('report.project_report.sheet_name')

      fill_report type, date.to_time.in_time_zone(LOCAL_TIMEZONE).to_date, project, period, user

      workbook
    end

    private

    attr_reader :workbook, :worksheet

    def fill_report(type, date, project, period, user)
      case type
      when PROJECT_REPORT
        call_project_service date, project, user
      when TEACHER_REPORT
        call_teacher_service period, date, user
      end
    end

    def call_project_service(date, project, user)
      FillProjectReportExcel.call date: date,
                                  project_id: project,
                                  worksheet: @worksheet,
                                  user: user
    end

    def call_teacher_service(period, date, user)
      if period == 'monthly'
        monthly_teacher_report date, user
      else
        weekly_teacher_report
      end
    end

    def monthly_teacher_report(date, user)
      FillMonthlyTeacherReport.call date: date,
                                    worksheet: @worksheet,
                                    user: user
    end

    def weekly_teacher_report; end
  end
end
