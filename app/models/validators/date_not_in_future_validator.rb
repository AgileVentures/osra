class DateNotInFutureValidator < ActiveModel::EachValidator
  include Helpers

  def validate_each(record, attribute, value)
    if !valid_date?(value)
      record.errors[attribute] << ('is not a valid date')
    elsif value.future?
      record.errors[attribute] << 'is not valid (cannot be in the future)'
    end
  end

end
