class ImportFile
  class << self
    def call path:, model:
      workbook = Spreadsheet.open path
      worksheet = workbook.worksheet model == 'Curs' ? 'Cursuri' : 'Proiecte'

      worksheet.each 1 do |row|
        values = row.to_a

        if model == 'Course'
          process_course values
        else
          process_project values
        end
      end
    end

    def process_course values
      Course.create! name:         values[0],
                     student_year: values[1].to_i,
                     semester:     values[2].to_i,
                     faculty:      values[3],
                     description:  values[4]
    end

    def process_project values
      Project.create! name:        values[0],
                      description: values[1]
    end
  end
end
