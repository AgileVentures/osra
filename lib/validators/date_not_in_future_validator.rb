class DateNotInFutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value <= Date.current
      record.errors[attribute] << (options[:message] || 'is not valid (cannot be in the future)')
    end
  end
end
