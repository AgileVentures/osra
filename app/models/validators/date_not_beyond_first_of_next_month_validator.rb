class DateNotBeyondFirstOfNextMonthValidator < ActiveModel::EachValidator
  include DateHelpers

  def validate_each(record, attribute, value)
    if valid_date?(value) && (value > Date.current.beginning_of_month.next_month)
      record.errors[attribute] << ("can not be later than the first of next month")
    end
  end
end
