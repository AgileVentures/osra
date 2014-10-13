class OrphanImporter

  CONFIG = Settings.import

  attr_reader :pending_orphans, :import_errors

  def initialize(file)
    @pending_orphans = []
    @import_errors = []
    @file = file
  end

  def self.to_orphan(fields)
    orphan = Orphan.new

    ['original_address_', 'current_address_'].each do |i|
      address_fields = fields.select { |k, _| k[i] }.map { |k, v| [(k.gsub i, ''), v] }.to_h
      address_fields['province'] = Province.find_by_code(address_fields['province'])
      orphan.send "#{i.chop}=", Address.new(address_fields)
    end

    orphan.attributes = fields.reject { |k, _| k['address'] || k['pending'] }
    orphan
  end

  def extract_orphans
    open_doc
    return import_errors unless valid?
    CONFIG.first_row.upto(@doc.last_row) { |record| extract record }
    valid? ? pending_orphans : import_errors
  end

  def valid?
    @import_errors.empty?
  end

  def open_doc
    @file =~ /[.]([^.]+)\z/
    @doc = Roo::Spreadsheet.open @file, extension: $1.to_s
    if @doc.last_row.nil? || (@doc.last_row < CONFIG.first_row)
      add_validation_error('Import file', 'Does not contain any orphan records')
    end
  rescue => e
    add_validation_error('Import file', 'Is not a valid Excel file. ' + e.to_s)
  end

  private

  def add_validation_error(ref, error)
    @import_errors << { ref: ref, error: error }
    false
  end

  def option_defined?(option)
    return true unless CONFIG.options[option].nil?
    add_validation_error('Import configuration', "Option values for #{option} not defined. Please check import settings.")
  end

  def process_option(record, col, option, val)
    if option_defined? option
      option_val = CONFIG.options[option].find { |opt| opt[:cell] == val }
      return option_val[:db] unless option_val.nil?
      add_validation_error("(#{record},#{col.column})", "Option value: #{val} is not defined for field: #{col.field}")
    end
  end

  def add_error_if_mandatory(record, col)
    if col.mandatory
      add_validation_error("(#{record},#{col.column})", "Missing mandatory field: #{col.field}")
    end
  end

  def process_column(record, col, val)
    case col.type
      when 'String'
        val
      when 'Date'
        Date.parse(val.to_s)
      when 'Integer'
        val.to_i
      when /(.+) options\z/i
        process_option record, col, $1, val
      else
        add_validation_error('Import configuration', "Invalid data type: #{col.type} defined for field: #{col.field}. Please check import settings.")
    end
  rescue => e
    add_validation_error("(#{record},#{col.column})", "Error reading #{col.type} value for field: #{col.field}. Exception: #{e.to_s}")
  end

  def extract(record)
    fields = {}
    CONFIG.columns.each do |col|
      val = @doc.cell(record, col.column)
      if val.nil?
        add_error_if_mandatory record, col
      else
        fields[col.field] = process_column record, col, val
      end
    end
    @pending_orphans << fields if valid?
  end

end