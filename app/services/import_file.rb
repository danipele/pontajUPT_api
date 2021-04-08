# frozen_string_literal: true

class ImportFile
  class << self
    def call(path:, model:, user:)
      workbook = Spreadsheet.open path
      worksheet = workbook.worksheet model == 'Course' ? 'Cursuri' : 'Proiecte'

      worksheet.each 1 do |row|
        values = row.to_a

        if model == 'Course'
          process_course values, user
        else
          process_project values, user
        end
      end
    end

    private

    def process_course(values, user)
      course = user.courses.create name: values[0],
                                   student_year: values[1].to_i,
                                   semester: values[2].to_i,
                                   cycle: values[3].downcase.capitalize,
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
  end
end
