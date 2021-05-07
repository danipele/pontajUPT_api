# frozen_string_literal: true

class DownloadReport
  class << self
    include Constants

    def call(type:, date:, project:, period:, user:)
      @workbook = Spreadsheet::Workbook.new

      fill_report type, date.to_time.in_time_zone(LOCAL_TIMEZONE).to_date, project, period, user

      @workbook
    end

    private

    attr_reader :workbook

    def fill_report(type, date, project, period, user)
      case type
      when PROJECT_REPORT
        call_project_service date, project, user
      when TEACHER_REPORT
        call_teacher_service period, date, user
      when ONLINE_REPORT
        call_online_report date, user
      end
    end

    def call_project_service(date, project, user)
      worksheet = @workbook.create_worksheet name: I18n.t('report.project_report.sheet_name')
      FillProjectReportExcel.call date: date,
                                  project_id: project,
                                  worksheet: worksheet,
                                  user: user
    end

    def call_teacher_service(period, date, user)
      if period == 'monthly'
        monthly_teacher_report date, user
      else
        weekly_teacher_report date, user
      end
    end

    def monthly_teacher_report(date, user)
      worksheet = @workbook.create_worksheet
      FillMonthlyTeacherReport.call date: date,
                                    worksheet: worksheet,
                                    user: user
    end

    def weekly_teacher_report(date, user)
      FillWeeklyTeacherReport.call date: date,
                                   workbook: @workbook,
                                   user: user
    end

    def call_online_report(date, user)
      FillOnlineReport.call date: date,
                            workbook: @workbook,
                            user: user
    end
  end
end
