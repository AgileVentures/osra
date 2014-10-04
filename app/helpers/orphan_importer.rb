class OrphanImporter
  require 'spreadsheet'

  @@config = Settings.import

  attr_reader :pending_orphans, :import_errors
  attr_writer :pending_list_id

  def initialize file
    @pending_orphans = []
    @import_errors = []
    @file = file
    @doc = doc
  end

  def self.to_orphan pending_orphan
    fields = pending_orphan.attributes
    orphan = Orphan.new
    address = Address.new
    address.province = Province.find_by_code(fields['original_address_province'])
    address.city = fields['original_address_city']
    address.neighborhood = fields['original_address_neighborhood']
    address.street = fields['original_address_street']
    address.details = fields['original_address_details']
    orphan.original_address = address
    address = Address.new
    address.province = Province.find_by_code(fields['current_address_province'])
    address.city = fields['current_address_city']
    address.neighborhood = fields['current_address_neighborhood']
    address.street = fields['current_address_street']
    address.details = fields['current_address_details']
    orphan.current_address = address
    orphan.attributes = fields.reject { |k, _| k['address'] || k['pending'] }
    orphan.orphan_status = OrphanStatus.find_by_name('Active')
    orphan
  end

  def extract_orphans
    @doc = doc
    if (@doc.last_row||0) < 4
      add_validation_error('Import file', 'Does not contain any orphan records')
    else
      @@config.first_row.upto(@doc.last_row) { |record| extract record }
    end
    valid? ? pending_orphans : import_errors
  end

  def save_pending_orphans
    @pending_orphans.each do |pending_orphan|
      pending_orphan.pending_orphan_list_id = @pending_list_id
      pending_orphan.save!
    end
  end



  def valid?
    @import_errors.empty?
  end

  private

  def doc
    case @file
      when String
        name = @file
        path = @file
      when ActionDispatch::Http::UploadedFile
        name = @file.original_filename
        path = @file.path
    end
    name =~ /[.]([^.]+)\z/
    Roo::Spreadsheet.open path, extension: $1.to_s
  end

  def extract record
    rec_valid = true
    fields = {}
    @@config.columns.each do |col|
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
              fields[col.field] = val.is_a?(Date) ? val : Date.parse(val)
            when 'Integer'
              fields[col.field] = val.to_i
            when /(.+) options\z/i
              if @@config.options[$1].nil?
                rec_valid = false
                add_validation_error('Import configuration', "Option values for #{$1} not defined. Please check import settings.")
              else
                option_val = @@config.options[$1].find { |opt| opt[:cell] == val }
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
        rescue
          rec_valid = false
          add_validation_error("(#{record},#{col.column})", "Error reading #{col.type} value for field: #{col.field}")
        end
      end
    end
    @pending_orphans << PendingOrphan.new(fields) if rec_valid
  end

  def add_validation_error(ref, error)
    @import_errors << {ref: ref, error: error}
  end

end