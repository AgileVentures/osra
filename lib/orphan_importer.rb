require_relative 'excel_upload'
require_relative 'import_orphan_settings'

class OrphanImporter
  attr_accessor :import_errors, :settings

  def initialize(file)
    @settings = ImportOrphanSettings.settings
    @pending_orphans = []
    @import_errors = []
    @file = file
  end

  def self.to_orphan(pending_orphan)
    pending_orphan.to_orphan
  end

  def extract_orphans
    spreadsheet = log_exceptions{ExcelUpload.upload(@file, settings.first_row)}
    orphan_list = import_orphans(spreadsheet) if spreadsheet
    return error_or_orphans
  end

  def add_import_errors(ref, error)
    @import_errors << { ref: ref, error: error }
    false
  end

  def valid?
    import_errors.empty?
  end

  def error_or_orphans
    valid? ? @pending_orphans : @import_errors
  end

  def import_orphans(doc)
    settings.first_row.upto(doc.last_row){ |row| import_orphan(doc, row) }
  end

  def import_orphan(doc, row)
    fields = Hash.new
    settings.columns.each do |col_settings|
      cell_val = doc.cell(row, col_settings.column)
      fields[col_settings.field] = process_column row, col_settings, cell_val
    end
    add_to_pending_orphans_if_valid(fields)
  end

  def add_to_pending_orphans_if_valid(fields)
    @pending_orphans << PendingOrphan.new(fields) if valid?
  end

  def process_column(row, col_settings, cell_val)
    log_exceptions(row, col_settings) do
      class_name = col_settings.type.split.first.classify
      full_class = ("ImportOrphanSettings::" + class_name + \
        "Column").constantize
      parsed_value = full_class.new(cell_val, col_settings).parse_value
    end
  end

  def log_exceptions(row=nil,col_settings=nil)
    begin
      yield
    rescue => e
      message = e.to_s
      message += " Error at row #{row}" if row
      if col_settings
        message += " for column #{col_settings.column}--#{col_settings.field}"
      end
      add_import_errors(e.class.name.split('::').last, message)
    end
  end
end

