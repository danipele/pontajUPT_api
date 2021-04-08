# frozen_string_literal: true

class FillProjectsExcel
  class << self
    def call(workbook:, projects:)
      worksheet = workbook.worksheet 'Proiecte'
      projects.zip((1..projects.length)).each do |project, row|
        worksheet.row(row).concat [project[:name], project[:hours_per_month], project[:restricted_start_hour],
                                   project[:restricted_end_hour], project[:description]]
      end

      workbook
    end
  end
end
