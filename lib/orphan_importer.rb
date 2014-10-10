class OrphanImporter

  @@config = Settings.import

  attr_reader :pending_orphans, :import_errors

  def initialize(file)
    @pending_orphans = []
    @import_errors = []
    @file = file
    @doc = doc
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

end