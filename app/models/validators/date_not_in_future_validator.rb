class DateNotInFutureValidator < ActiveModel::EachValidator
  include DateHelpers

  def validate_each(record, attribute, value)
    if valid_date?(value) && value.future?
      record.errors[attribute] << ('is not valid (cannot be in the future)')
    end
  end

end



