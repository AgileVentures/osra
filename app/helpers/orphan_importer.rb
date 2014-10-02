module OrphanImporter
  require 'spreadsheet'

  def to_orphan fields
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
    orphan.attributes = fields.reject { |k, _| k['address'] }
    orphan.orphan_status = OrphanStatus.find_by_name('Active')
    orphan
  end

  def extract_orphans file
    case file
      when String
        name = file
        path = file
      when ActionDispatch::Http::UploadedFile
        name = file.original_filename
        path = file.path
    end
    name =~ /[.]([^.]+)\z/
    @doc = Roo::Spreadsheet.open path, extension: $1.to_s
    @extracted_errors = []
    @extracted_orphans = []

    @config = Settings.import
    if (@doc.last_row||0) < 4
      add_validation_error('Import file','Does not contain any orphan records')
    else
      @config.first_row.upto(@doc.last_row) { |record| extract record }
    end
    {errors: @extracted_errors, orphans: @extracted_orphans}
  end

  def extract record
    rec_valid = true
    fields = {}
    @config.columns.each do |col|
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
              if @config.options[$1].nil?
                rec_valid = false
                add_validation_error('Import configuration', "Option values for #{$1} not defined. Please check import settings.")
              else
                option_val = @config.options[$1].find { |opt| opt[:cell] == val }
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
    if rec_valid
      orphan = to_orphan(fields)
      if orphan.valid?
        @extracted_orphans << orphan
      else
        add_validation_error("(Row #{record})", "Errors parsing orphan record: #{orphan.errors.full_messages}")
      end
    end
  end

  def add_validation_error(ref, error)
    @extracted_errors << {ref: ref, error: error}
  end
end