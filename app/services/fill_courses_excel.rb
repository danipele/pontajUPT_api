# frozen_string_literal: true

class FillCoursesExcel
  class << self
    include Constants

    def call(workbook:, courses:)
      worksheet = workbook.worksheet I18n.t('course.sheet_name')
      courses.zip((1..courses.length)).each do |course, row|
        worksheet.row(row).concat [course[:name], course[:student_year], course[:semester], course[:cycle],
                                   course[:faculty], course[:description]]
      end

      workbook
    end
  end
end
