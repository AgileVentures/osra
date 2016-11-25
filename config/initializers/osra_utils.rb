PRESENCE_VALIDATORS = [ActiveRecord::Validations::PresenceValidator,
                       ValidDatePresenceValidator]

def en_ar_country(country)
  en_country = ISO3166::Country[country]
  ar_country = I18n.with_locale :ar do
    I18n.t country, default: :missing
  end

  ("(#{en_country}) #{ar_country}").html_safe
end
