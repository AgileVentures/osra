class OrphanImporter

  CONFIG = Settings.import

  attr_reader :pending_orphans, :import_errors

  def initialize(file)
    @pending_orphans = []
    @import_errors = []
    @file = file
    @doc = doc
  end

  def self.to_orphan(fields)
    orphan = Orphan.new

    ['original_address_', 'current_address_'].each do |i|
      address_fields = fields.select { |k,_| k[i]}.map {|k,v| [(k.gsub i, ''), v]}.to_h
      address_fields['province'] = Province.find_by_code(address_fields['province'])
      orphan.send "#{i.chop}=", Address.new(address_fields)
    end

    orphan.attributes = fields.reject { |k, _| k['address'] || k['pending'] }
    orphan
  end

  def extract_orphans
    return import_errors unless valid?
    if (@doc.last_row||0) < CONFIG.first_row
      add_validation_error('Import file', 'Does not contain any orphan records')
    else
      CONFIG.first_row.upto(@doc.last_row) { |record| extract record }
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
    add_validation_error('Import file', 'Is not a valid Excel file. ' + e.to_s)
  end

  def add_validation_error(ref, error)
    @import_errors << { ref: ref, error: error }
  end

  def extract(record)
    rec_valid = true
    fields = {}
    CONFIG.columns.each do |col|
      val = @doc.cell(record, col.column)
      if val.nil?
        if col.mandatory
          rec_valid = false
          add_validation_error("(#{record},#{col.column})", "Missing mandatory field: #{col.field}")
        end
      else
        begin
          case col.type
            when 'String'
              fields[col.field] = val
            when 'Date'
              fields[col.field] = Date.parse(val.to_s)
            when 'Integer'
              fields[col.field] = val.to_i
            when /(.+) options\z/i
              if CONFIG.options[$1].nil?
                rec_valid = false
                add_validation_error('Import configuration', "Option values for #{$1} not defined. Please check import settings.")
              else
                option_val = CONFIG.options[$1].find { |opt| opt[:cell] == val }
                if option_val.nil?
                  rec_valid = false
                  add_validation_error("(#{record},#{col.column})", "Option value: #{val} is not defined for field: #{col.field}")
                else
                  fields[col.field] = option_val[:db]
                end
              end
            else
              rec_valid = false
              add_validation_error('Import configuration', "Invalid data type: #{col.type} defined for field: #{col.field}. Please check import settings.")
          end
        rescue => e
          rec_valid = false
          add_validation_error("(#{record},#{col.column})", "Error reading #{col.type} value for field: #{col.field}. Exception: #{e.to_s}")
        end
      end
    end
    @pending_orphans << fields if rec_valid
  end

end