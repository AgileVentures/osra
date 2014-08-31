class DateNotInFutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.future?
      record.errors[attribute] << (options[:message] || 'is not valid (cannot be in the future)')
    end
  end
end
