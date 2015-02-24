module StartdateBeyondOsraEstablishmentValidation
	include ValidatorHelpers

	OSRA_ESTABLISHMENT_DATE = Date.new(2012,04,01)

	 def start_date_beyound_OSRA_establishment_date
    if (valid_date? start_date) && (start_date < OSRA_ESTABLISHMENT_DATE)
      errors.add(:start_date, "must be beyond the OSRA establishment date of #{OSRA_ESTABLISHMENT_DATE}")
    end
  end

end