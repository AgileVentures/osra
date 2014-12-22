require_relative 'excel_upload'
require_relative 'import_orphan_settings'

class OrphanImporter
  attr_accessor :import_errors, :settings

  def initialize(file, partner)
    @settings = ImportOrphanSettings.settings
    @pending_orphans = []
    @import_errors = []
    @file = file
    @partner = partner
    @duplicates_hash = Hash.new([])
  end

  def extract_orphans
    spreadsheet = upload_spreadsheet
    import_orphans(spreadsheet) and check_for_duplicates
    error_or_orphans
  end

  def upload_spreadsheet
    log_exceptions { ExcelUpload.upload(@file, settings.first_row) }
  end

  def add_import_errors(ref, error = nil)
    @import_errors << { ref: ref, error: error }
  end

  def valid?
    import_errors.empty?
  end

  def error_or_orphans
    valid? ? @pending_orphans : @import_errors
  end

  def import_orphans(doc)
    return unless doc
    settings.first_row.upto(doc.last_row){ |row| import_orphan(doc, row) }
  end

  def import_orphan(doc, row)
    fields = parse_orphan(doc, row)
    add_to_duplicates(fields, row)
    check_orphan_validity(fields, row) and add_to_pending_orphans_if_valid(fields)
  end

  def parse_orphan(doc, row)
    settings.columns.inject({}) do |memo, col_settings|
      cell_val = doc.cell(row, col_settings.column)
      memo[col_settings.field] = process_column row, col_settings, cell_val
      memo
    end
  end

  def add_to_duplicates(fields, row)
    hash_key = fields.select{ |k, _| %w[name father_name mother_name].include? k }
    @duplicates_hash[hash_key] += [row]
  end

  def check_orphan_validity(fields, row)
    orphan = PendingOrphan.new(fields).to_orphan
    orphan.partner = @partner
    return true if orphan.valid?
    add_import_errors(ref: "invalid orphan attributes for row #{row}",
                      error: orphan.errors.full_messages)
  end

  def check_for_duplicates
    @duplicates_hash.values.select { |v| v.size > 1 }.each do |v|
      add_import_errors "duplicate entries found on rows #{v.join(', ')}",
                        "Orphan's name, mother's name & father's name are the same."
    end
  end

  def add_to_pending_orphans_if_valid(fields)
    @pending_orphans << PendingOrphan.new(fields) if valid?
  end

  def process_column(row, col_settings, cell_val)
    log_exceptions(row, col_settings) do
      class_name = col_settings.type.split.first.classify
      full_class = ("ImportOrphanSettings::#{class_name}Column").constantize
      full_class.new(cell_val, col_settings).parse_value
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
      false
    end
  end
end

