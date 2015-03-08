class ValidDatePresenceValidator < ActiveModel::EachValidator
  include DateHelpers

  def validate_each(record, attribute, value)
    unless valid_date? value
      record.errors[attribute] << ('is not a valid date')
    end
  end

end

