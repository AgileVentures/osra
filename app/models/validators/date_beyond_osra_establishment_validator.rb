class DateBeyondOsraEstablishmentValidator < ActiveModel::EachValidator
  OSRA_ESTABLISHMENT_DATE = Date.new(2012,04,01)
  include DateHelpers

  def validate_each(record, attribute, value)
    if valid_date?(value) && (value < OSRA_ESTABLISHMENT_DATE)
      record.errors[attribute] << ("is not valid (cannot be earlier than the OSRA establishment date of #{OSRA_ESTABLISHMENT_DATE})")
    end
  end

end
