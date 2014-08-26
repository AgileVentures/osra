class DateNotInFutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value <= Date.current
      record.errors[attribute] << (options[:message] || 'is not valid (cannot be in the future)')
    end
  end
end

def date_attr_validator_class(options)
  Class.new do
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    def new_record?
      true
    end

    def persisted?
      false
    end

    def self.name
      'Validator'
    end

    attr_accessor :date_attr

    validates :date_attr, date_not_in_future: options
  end
end