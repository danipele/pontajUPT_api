class DownloadExcelTemplate
  class << self
    def call header:, sheet_name:
      workbook = Spreadsheet::Workbook.new
      worksheet = workbook.create_worksheet name: sheet_name

      worksheet.row(0).concat header
      header_format = Spreadsheet::Format.new weight: :bold
      worksheet.row(0).default_format = header_format

      output_path = Tempfile.new.path
      workbook.write output_path
      output_path
    end
  end
end
