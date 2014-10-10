class OrphanImporter

  @@config = Settings.import

  attr_reader :pending_orphans, :import_errors

  def initialize(file)
    @pending_orphans = []
    @import_errors = []
    @file = file
    @doc = doc
  end

  def extract_orphans
    return import_errors unless valid?
    if (@doc.last_row||0) < @@config.first_row
      add_validation_error('Import file', 'Does not contain any orphan records')
    else
      @@config.first_row.upto(@doc.last_row) { |record| extract record }
    end
    valid? ? pending_orphans : import_errors
  end

  def valid?
    @import_errors.empty?
  end

  private

  def doc
    @file =~ /[.]([^.]+)\z/
    Roo::Spreadsheet.open @file, extension: $1.to_s
  rescue => e
    add_validation_error('Import file','Is not a valid Excel file. ' + e.to_s)
  end

  def add_validation_error(ref, error)
    @import_errors << {ref: ref, error: error}
  end

  def extract(record)
    rec_valid = true
    fields = {}
  end

end