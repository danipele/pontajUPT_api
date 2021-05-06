# frozen_string_literal: true

class FillMonthlyTeacherReport
  class << self
    include Constants

    def call(date:, worksheet:, user:)
      attributes date, worksheet, user

      worksheet_format
      fill_headers
      fill_title
      fill_date
      fill_table
    end

    private

    attr_reader :date, :user, :worksheet

    def attributes(date, worksheet, user)
      @date = date
      @worksheet = worksheet
      @user = user
    end

    def worksheet_format
      @worksheet.default_format = Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle,
                                                          text_wrap: true

      @worksheet.column(1).width = 25
      @worksheet.column(17).width = 25
      @worksheet.row(6).height = 100
      @worksheet.row(7).height = 10
      @worksheet.row(8).height = 10
    end

    def fill_headers
      fill_university
      fill_department
    end

    def fill_university
      @worksheet.row(0).concat [I18n.t('report.university_name')]
      @worksheet.row(0).default_format = Spreadsheet::Format.new horizontal_align: :left
    end

    def fill_department
      @worksheet.row(1).concat [I18n.t('report.department')]
      @worksheet.row(1).default_format = Spreadsheet::Format.new horizontal_align: :left
    end

    def fill_title
      @worksheet.merge_cells 3, 0, 3, 20
      @worksheet.row(3).concat [I18n.t('report.teacher_report.monthly_title')]
    end

    def fill_date
      @worksheet.merge_cells 4, 0, 4, 20
      @worksheet.row(4).concat ["#{I18n.l(@date, format: '%B')} #{@date.year}"]
    end

    def fill_table
      fill_table_header
      fill_additional_rows
      fill_table_cells
    end

    def fill_table_header
      fill_table_header_info
      fill_table_header_course_activities
      fill_table_header_other_activities
      fill_table_header_obs
      fill_table_header_total_hours

      (3..16).each do |col|
        @worksheet.row(6).set_format col, rotate_format
        @worksheet.column(col).width = 4
      end
    end

    def fill_table_header_info
      @worksheet.row(6).concat [
        I18n.t('report.teacher_report.header.period'),
        I18n.t('report.teacher_report.header.name'),
        I18n.t('report.teacher_report.header.didactic_degree')
      ]
      @worksheet.row(6).set_format 0, rotate_format
      (1..2).each { |col| @worksheet.row(6).set_format col, simple_format }
    end

    def fill_table_header_course_activities
      @worksheet.row(6).concat [
        "ore #{I18n.t 'course.subactivities.course'}", "ore #{I18n.t 'course.subactivities.seminar'}",
        "ore #{I18n.t 'course.subactivities.laboratory'}", "ore #{I18n.t 'course.subactivities.project'}",
        "ore #{I18n.t 'other_activities.doctoralStudentsGuidance'}",
        "ore #{I18n.t 'course.subactivities.consultations'}",
        "ore #{I18n.t 'course.subactivities.evaluation'}",
        "ore #{I18n.t 'course.subactivities.teachingActivityPreparation'}"
      ]
    end

    def fill_table_header_other_activities
      @worksheet.row(6).concat [
        "ore #{I18n.t 'other_activities.researchDocumentation'}",
        "ore #{I18n.t 'other_activities.projectFinancingOpportunitiesDocumentation'}",
        "ore #{I18n.t 'other_activities.researchProjectsElaboration'}",
        "ore #{I18n.t 'other_activities.cooperationManagement'}",
        "ore #{I18n.t 'other_activities.delegationDays'}",
        "ore #{I18n.t 'other_activities.otherActivities'}"
      ]
    end

    def fill_table_header_obs
      @worksheet.rows[6][17] =
        "#{I18n.t('report.teacher_report.header.observations')} (#{I18n.t('holidays.vacation')}" \
        ", #{I18n.t('holidays.sickLeave')}, #{I18n.t('holidays.unpaidLeave')}, #{I18n.t('holidays.childGrowthLeave')}" \
        ", #{I18n.t('holidays.maternityLeave')}, #{I18n.t('other_activities.departureWithScholarship')}" \
        ", #{I18n.t('holidays.unmotivatedAbsences')})"

      @worksheet.row(6).set_format 17, simple_format
    end

    def fill_table_header_total_hours
      @worksheet.rows[6][18] = I18n.t('report.teacher_report.header.total_hours')
      @worksheet.row(6).set_format 18, rotate_format
    end

    def fill_additional_rows
      fill_period_cell
      fill_index_cells
    end

    def fill_period_cell
      @worksheet.merge_cells 7, 0, 7, 18
      @worksheet.row(7).concat [
        "#{I18n.t 'report.teacher_report.period'} #{@date.beginning_of_month} - #{@date.end_of_month}"
      ]
      @worksheet.row(7).set_format 0, italic_format
      @worksheet.row(7).set_format 18, italic_format
    end

    def fill_index_cells
      (0..18).each do |col|
        @worksheet.row(8).concat [col + 1]
        @worksheet.row(8).set_format col, italic_format
      end
    end

    def fill_table_cells
      end_of_week = @date.end_of_week
      row = 9
      loop do
        handle_week end_of_week, row
        break if end_of_week.month != @date.month || end_of_week.day == @date.end_of_month.day

        end_of_week += 7.days
        row += 1
      end

      merge_info_cells row
    end

    def merge_info_cells(row)
      @worksheet.merge_cells 9, 1, row, 1
      @worksheet.merge_cells 9, 2, row, 2
      (9..row).each do |row_idx|
        @worksheet.row(row_idx).set_format 1, border_format
        @worksheet.row(row_idx).set_format 2, border_format
      end
    end

    def handle_week(end_of_week, row)
      fill_week_period end_of_week, row

      events = @user.events.filter do |event|
        start_date = event.start_date.to_date
        start_date.end_of_week == end_of_week && start_date.month == @date.month
      end

      fill_week events, row, end_of_week
    end

    def fill_week(events, row, end_of_week)
      fill_hours events, row
      fill_obs events, row
      fill_total_hours row
      fill_working_hours row, end_of_week
    end

    def fill_week_period(end_of_week, row)
      @worksheet.row(row).concat ['']
      @worksheet.rows[row][0] = "#{end_of_week.beginning_of_week.strftime('%d')}...#{end_of_week.strftime('%d')}"
      @worksheet.row(row).set_format 0, border_format
    end

    def fill_hours(events, row)
      fill_teaching_hours events, row
      fill_other_activity_hours events, row
    end

    def fill_teaching_hours(events, row)
      fill_course_hours events, row
      fill_seminar_hours events, row
      fill_laboratory_hours events, row
      fill_project_hours events, row
      fill_consultations_hours events, row
      fill_evaluation_hours events, row
      fill_preparation_hours events, row
    end

    def fill_course_hours(events, row)
      course_hours = calc_hours events_with_type(COURSE, events)
      @worksheet.rows[row][3] = course_hours unless course_hours.zero?
      @worksheet.row(row).set_format 3, border_format
    end

    def fill_seminar_hours(events, row)
      seminar_hours = calc_hours events_with_type(SEMINAR, events)
      @worksheet.rows[row][4] = seminar_hours unless seminar_hours.zero?
      @worksheet.row(row).set_format 4, border_format
    end

    def fill_laboratory_hours(events, row)
      laboratory_hours = calc_hours events_with_type(LABORATORY, events)
      @worksheet.rows[row][5] = laboratory_hours unless laboratory_hours.zero?
      @worksheet.row(row).set_format 5, border_format
    end

    def fill_project_hours(events, row)
      project_hours = calc_hours events_with_type(PROJECT_HOUR, events)
      @worksheet.rows[row][6] = project_hours unless project_hours.zero?
      @worksheet.row(row).set_format 6, border_format
    end

    def fill_consultations_hours(events, row)
      consultations_hours = calc_hours events_with_type(CONSULTATIONS, events)
      @worksheet.rows[row][8] = consultations_hours unless consultations_hours.zero?
      @worksheet.row(row).set_format 8, border_format
    end

    def fill_evaluation_hours(events, row)
      evaluation_hours = calc_hours events_with_type(EVALUATION, events)
      @worksheet.rows[row][9] = evaluation_hours unless evaluation_hours.zero?
      @worksheet.row(row).set_format 9, border_format
    end

    def fill_preparation_hours(events, row)
      preparation_hours = calc_hours events_with_type(TEACHING_ACTIVITY_PREPARATION, events)
      @worksheet.rows[row][10] = preparation_hours unless preparation_hours.zero?
      @worksheet.row(row).set_format 10, border_format
    end

    def fill_other_activity_hours(events, row)
      fill_doctoral_guidance_hours events, row
      fill_research_hours events, row
      fill_financing_hours events, row
      fill_elaboration_hours events, row
      fill_cooperation_hours events, row
      fill_delegation_hours events, row
      fill_other_activities_hours events, row
    end

    def fill_doctoral_guidance_hours(events, row)
      doctoral_guidance_hours = calc_hours events_with_type(DOCTORAL_STUDENTS_GUIDANCE, events)
      @worksheet.rows[row][7] = doctoral_guidance_hours unless doctoral_guidance_hours.zero?
      @worksheet.row(row).set_format 7, border_format
    end

    def fill_research_hours(events, row)
      research_hours = calc_hours events_with_type(RESEARCH_DOCUMENTATION, events)
      @worksheet.rows[row][11] = research_hours unless research_hours.zero?
      @worksheet.row(row).set_format 11, border_format
    end

    def fill_financing_hours(events, row)
      financing_hours = calc_hours events_with_type(PROJECT_FINANCING_OPPORTUNITIES_DOCUMENTATION, events)
      @worksheet.rows[row][12] = financing_hours unless financing_hours.zero?
      @worksheet.row(row).set_format 12, border_format
    end

    def fill_elaboration_hours(events, row)
      elaboration_hours = calc_hours events_with_type(RESEARCH_PROJECTS_ELABORATION, events)
      @worksheet.rows[row][13] = elaboration_hours unless elaboration_hours.zero?
      @worksheet.row(row).set_format 13, border_format
    end

    def fill_cooperation_hours(events, row)
      cooperation_hours = calc_hours events_with_type(COOPERATION_MANAGEMENT, events)
      @worksheet.rows[row][14] = cooperation_hours unless cooperation_hours.zero?
      @worksheet.row(row).set_format 14, border_format
    end

    def fill_delegation_hours(events, row)
      fill_delegation_hours = calc_hours events_with_type(INTERNAL_DELEGATION_DAYS, events)
      fill_delegation_hours += calc_hours events_with_type(EXTERNAL_DELEGATION_DAYS, events)
      @worksheet.rows[row][15] = fill_delegation_hours unless fill_delegation_hours.zero?
      @worksheet.row(row).set_format 15, border_format
    end

    def fill_other_activities_hours(events, row)
      other_activities_hours = calc_hours events_with_type(OTHER_ACTIVITIES, events)
      @worksheet.rows[row][16] = other_activities_hours unless other_activities_hours.zero?
      @worksheet.row(row).set_format 16, border_format
    end

    def events_with_type(type, events)
      events.filter { |event| (event.activity.is_a?(CourseHour) ? event.activity.type : event.activity.name) == type }
    end

    def calc_hours(events)
      events.inject(0) do |sum, event|
        end_hour = event.end_date.to_time.hour.zero? ? 24 : event.end_date.to_time.hour
        start_hour = event.start_date.to_time.hour
        sum + end_hour - start_hour
      end
    end

    def fill_obs(events, row)
      obs = holidays_events events

      unless events_with_type(DEPARTURE_WITH_SCHOLARSHIP, events).empty?
        obs << I18n.t('other_activities.departureWithScholarship')
      end

      @worksheet.rows[row][17] = obs.join ', '
      @worksheet.row(row).set_format 17, border_format
    end

    def holidays_events(events)
      events.filter { |event| event.activity.is_a? Holiday }.map do |event|
        I18n.t "holidays.#{event.activity.name}"
      end.uniq
    end

    def fill_total_hours(row)
      total_hours = (3..16).inject(0) do |sum, col|
        sum + @worksheet.rows[row][col].to_i
      end

      @worksheet.rows[row][18] = total_hours
      @worksheet.row(row).set_format 18, border_format
    end

    def fill_working_hours(row, end_of_week)
      working_hours = working_hours end_of_week

      @worksheet.rows[row][19] = working_hours
      @worksheet.row(row).set_format 19, border_format
    end

    def working_hours(end_of_week)
      start_of_week_month = end_of_week.beginning_of_week.month

      if start_of_week_month != @date.month
        (end_of_week.day < 3 ? 0 : end_of_week.day - 2) * 8
      elsif end_of_week.month != @date.month
        days = days_on_last_week end_of_week
        days > 5 ? 40 : (days * 8)
      else
        40
      end
    end

    def days_on_last_week(end_of_week)
      @date.end_of_month.day - end_of_week.beginning_of_week.day + 1
    end

    def simple_format
      Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, text_wrap: true, border: :thin,
                              bold: true
    end

    def rotate_format
      Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, text_wrap: true, border: :thin,
                              bold: true, rotation: 90
    end

    def italic_format
      Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, border: :thin, italic: true
    end

    def border_format
      Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, border: :thin, text_wrap: true
    end
  end
end
