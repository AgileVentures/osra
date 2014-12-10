class ImportOrphanSettings
  class ImportConfigurationError < StandardError
  end

  class DataColumn
    attr_reader :column_value
    attr_accessor :settings, :column_settings

    def initialize column_value, column_settings
      @settings = Settings.import
      @column_value = column_value
      @column_settings = column_settings
    end

    def class_name
      self.class.name.split('::').last
    end

    def data_type
      class_name.gsub(/Column/, "").downcase
    end

    def options
      settings.options["#{data_type}"]
    end

    def has_options?
      settings.options[data_type].present?
    end

    def mandatory?
      column_settings.mandatory
    end

    def raise_error_if_mandatory_and_blank?
      if mandatory? && column_value.blank?
        raise ImportConfigurationError, "mandatory field is blank"
      end
    end

    def permitted_options
      options.collect {|opt| opt.cell}
    end

    def valid_option?
      strict_valid = permitted_options.include? column_value
      mandatory? ? strict_valid : strict_valid || column_value.blank?
    end

    def to_val
      column_value
    end

    def convert_option_value
      return column_value if column_value.blank?
      option = options.find { |opt| opt[:cell] == column_value }
      option[:db]
    end

    def parse_value
      return self.to_val unless has_options?
      return convert_option_value if valid_option?
      raise ImportConfigurationError, "column is invalid"
    end
  end

  class StringColumn < ImportOrphanSettings::DataColumn
  end
  class DateColumn < ImportOrphanSettings::DataColumn
    def to_val
      raise_error_if_mandatory_and_blank?
      return if @column_value.blank?
      Date.parse(@column_value.to_s)
    end
  end
  class IntegerColumn < ImportOrphanSettings::DataColumn
    def to_val
      raise_error_if_mandatory_and_blank?
      return if @column_value.blank?
      @column_value.to_i
    end
  end
  class BooleanColumn < ImportOrphanSettings::DataColumn
  end
  class FatherColumn < ImportOrphanSettings::DataColumn
  end
  class MotherColumn < ImportOrphanSettings::DataColumn
  end
  class GenderColumn < ImportOrphanSettings::DataColumn
  end
  class ProvinceColumn < ImportOrphanSettings::DataColumn
  end

  def self.settings
    Settings.import
  end
end


