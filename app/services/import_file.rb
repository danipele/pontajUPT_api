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
      user.courses.create name: values[0],
                          student_year: values[1].to_i,
                          semester: values[2].to_i,
                          cycle: values[3],
                          faculty: values[4],
                          description: values[5]
    end

    def process_project(values, user)
      user.projects.create name: values[0],
                           description: values[1]
    end
  end
end
