# frozen_string_literal: true

class ImportFile
  class << self
    include Constants

    def call(path:, model:, user:)
      workbook = Spreadsheet.open path
      worksheet = workbook.worksheet model == COURSE_MODEL ? I18n.t('course.sheet_name') : I18n.t('project.sheet_name')

      raise StandardError unless worksheet

      worksheet.each 1 do |row|
        process_entity row, model, user
      end

      worksheet.rows.count - 1
    end

    private

    def process_entity(row, model, user)
      values = row.to_a

      if model == COURSE_MODEL
        process_course values, user
      else
        process_project values, user
      end
    end

    def process_course(values, user)
      course = user.courses.create name: values[0],
                                   student_year: values[1].to_i,
                                   semester: values[2].to_i,
                                   cycle: cycle_value(values[3].to_i),
                                   faculty: values[4],
                                   description: values[5]

      course.add_course_hours
    end

    def process_project(values, user)
      user.projects.create name: values[0],
                           hours_per_month: values[1].blank? ? nil : values[1].to_i,
                           restricted_start_hour: values[2].blank? ? nil : values[2].to_i,
                           restricted_end_hour: values[3].blank? ? nil : values[3].to_i,
                           description: values[4]
    end

    def cycle_value(cycle)
      case cycle
      when 1
        'bachelor'
      when 2
        'master'
      when 3
        'phd'
      end
    end
  end
end
