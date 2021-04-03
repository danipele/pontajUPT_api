# frozen_string_literal: true

class CreateExcelTemplate
  class << self
    def call(header:, sheet_name:)
      workbook = Spreadsheet::Workbook.new
      worksheet = workbook.create_worksheet name: sheet_name
      set_columns_width(worksheet, header.length)

      worksheet.row(0).concat header
      header_format = Spreadsheet::Format.new weight: :bold
      worksheet.row(0).default_format = header_format

      workbook
    end

    private

    def set_columns_width(worksheet, length)
      worksheet.column(0).width = 30

      if length == 2
        worksheet.column(1).width = 50
      else
        worksheet.column(1).width = 10
        worksheet.column(2).width = 10
        worksheet.column(3).width = 30
        worksheet.column(4).width = 30
        worksheet.column(5).width = 50
      end
    end
  end
end
