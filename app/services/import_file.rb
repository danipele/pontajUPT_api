class ImportFile
  class << self
    def call path:, model:
      workbook = Spreadsheet.open path
      worksheet = workbook.worksheet model == 'Course' ? 'Cursuri' : 'Proiecte'

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
                     cycle:        values[3],
                     faculty:      values[4],
                     description:  values[5]
    end

    def process_project values
      Project.create! name:        values[0],
                      description: values[1]
    end
  end
end
