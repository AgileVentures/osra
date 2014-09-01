class DateNotInFutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !valid_date?(value)
      record.errors[attribute] << ('is not a valid date')
    elsif value.future?
      record.errors[attribute] << (options[:message] || 'is not valid (cannot be in the future)')
    end
  end

  private

  def valid_date?(date)
    Date.parse(date.to_s)
  rescue ArgumentError
    return false
  else
    return true
  end
end
