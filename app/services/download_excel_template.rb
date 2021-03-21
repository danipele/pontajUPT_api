class DownloadExcelTemplate
  def self.call(header:, sheet_name:)
    spreadsheet = Spreadsheet::Workbook.new
    sheet = spreadsheet.create_worksheet name: sheet_name

    sheet.row(0).concat header
    header_format = Spreadsheet::Format.new weight: :bold
    sheet.row(0).default_format = header_format

    output_path = Tempfile.new.path
    spreadsheet.write output_path
    output_path
  end
end
