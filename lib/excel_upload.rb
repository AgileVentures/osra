class ExcelUpload
  class ExcelImportError < StandardError
  end
  def self.upload(file, first_row)
    begin
      doc = Roo::Spreadsheet.open file, extension: extension(file)
    rescue => e
      raise ExcelImportError, 'Is not a valid Excel file. ' + e.to_s
    end
    if empty_file?(doc, first_row)
      raise ExcelImportError, 'Does not contain any orphan records'
    end
    doc
  end

  def self.extension(file)
    file =~ /[.]([^.]+)\z/
    $1.to_s
  end

  def self.empty_file?(doc, first_row)
    doc.last_row.nil? || doc.last_row < first_row
  end
end
