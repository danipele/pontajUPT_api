# frozen_string_literal: true

class DownloadReport
  class << self
    include Constants

    def call(params:)
      @workbook = Spreadsheet::Workbook.new

      params[:date] = params[:date].to_time.in_time_zone(LOCAL_TIMEZONE).to_date
      fill_report params

      @workbook
    end

    private

    attr_reader :workbook

    def fill_report(params)
      case params[:type]
      when PROJECT_REPORT
        call_project_service params
      when TEACHER_REPORT
        call_teacher_service params
      when ONLINE_REPORT
        call_online_report params
      end
    end

    def call_project_service(params)
      worksheet = @workbook.create_worksheet name: I18n.t('report.project_report.sheet_name')
      FillProjectReportExcel.call params: params,
                                  worksheet: worksheet
    end

    def call_teacher_service(params)
      if params[:period] == 'monthly'
        monthly_teacher_report params
      else
        weekly_teacher_report params
      end
    end

    def monthly_teacher_report(params)
      worksheet = @workbook.create_worksheet
      FillMonthlyTeacherReport.call params: params,
                                    worksheet: worksheet
    end

    def weekly_teacher_report(params)
      FillWeeklyTeacherReport.call params: params,
                                   workbook: @workbook
    end

    def call_online_report(params)
      FillOnlineReport.call params: params,
                            workbook: @workbook
    end
  end
end
