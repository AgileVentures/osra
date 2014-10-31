class OrphanImporter
  attr_accessor :import_errors, :settings

  class ImportConfigurationError < StandardError
  end

  class ExcelUpload
    class ExcelImportError < StandardError
    end
    def self.upload(file, first_row)
      begin
        doc = Roo::Spreadsheet.open file, extension: extension(file)
      rescue => e
        raise ExcelImportError, 'Is not a valid Excel file. ' + e.to_s
      end
      if empty_file?(doc)
        raise ExcelImportError, 'Does not contain any orphan records'
      end
      doc
    end


    def self.extension(file)
      file =~ /[.]([^.]+)\z/
      $1.to_s
    end

    def self.empty_file?(doc, first_row)
      doc.last_row.nil? || doc.last_row < CONFIG.first_row
    end
  end

  class ImportOrphanSettings
    class DataColumn
      attr_reader :column_value
      def initialize column_value
        @column_value = column_value
      end
      def class_name
        e.class.name.split('::').last
      end
      def data_type
        class_name.gsub(/Column/, "").downcase
      end
      def options
        settings.options[:data_type]
      end
      def has_options?
        settings.options[data_type].present?
      end
      def permitted_options
        options.collect {|opt| opt.cell}
      end
      def valid_option?
        permitted_options.include? column_value
      end
      def to_val
        @column_value
      end
      def convert_option_value
        option = options.find { |opt| opt[:cell] == val }
        option[:db}
      end
      def parse_value
        return self.to_val unless has_options?
        return convert_option_value if valid_option?
        raise CustomeError
      end
    end
    class StringColumn < DataColumn
    end
    class DateColumn < DataColumn
    end
    class IntegerColumn < DataColumn
    end
    class BooleanColumn < DataColumn
    end
    class MotherColumn < DataColumn
    end
    class GenderColumn < DataColumn
    end
    class ProvinceColumn < DataColumn
    end
    def self.settings
      Settings.import
    end
  end

  def initialize(file)
    @pending_orphans = []
    @import_errors = []
    @file = file
  end

  def extract_orphans
    settings = ImportOrphanSettings.settings
    spreadsheet = log_exceptions{ ExcelUpload.upload(@file, settings.first_row) }
    orphan_list = import_orphans(spreadsheet, settings.first_row)
    return error_or_orphans
  end

  def add_import_errors(ref, error)


  def valid?
    import_errors.empty?
  end

  def import_orphans(doc)
    settings.first_row.upto(doc.last_row){ |row| import_orphan(doc, row) }
  end

  def import_orphan(doc, row)
    fields = Hash.new
    settings.columns.each do |column|
      val = doc.cell(row, column)
      add_error_if_nil_and_mandatory(row, column, val)
      fields[column.field] = process_column row, col, val
    end
    add_to_pending_orphans_if_valid(fields)
  end

  def add_to_pending_orphans_if_valid(fields)
    @pending_orphans << PendingOrphan.new(fields) if valid?
  end

  def add_error_if_nil_and_mandatory(row, col, val)
    if val.nil? && col.mandatory
      add_validation_error("(#{row},#{col.column})",
        "Missing mandatory field: #{col.field}")
    end
  end

  def option_defined?(option)
    return true unless settings.options[option].nil?
    add_validation_error 'Import configuration',
      "Option values for #{option} not defined. Please check import settings."
  end

  def process_column(row, col, val)
    case col.type
      when 'String'
        val
      when 'Date'
        Date.parse(val.to_s)
      when 'Integer'
        val.to_i
      when /(.+) options\z/i
        process_option row, col, $1, val
      else
        add_import_errors "Import Configuration",
          "Invalid data type: #{col.type} defined for field: #{col.field}." + \
          " Please check import settings."
    end
  end

   def process_option(row, col, option, val)
    if option_defined? option
      option_val = settings.options[option].find { |opt| opt[:cell] == val }
      return option_val[:db] unless option_val.nil?
      add_import_errors "(#{record},#{col.column})",
        "Option value: #{val} is not defined for field: #{col.field}"
    end
  end
end

