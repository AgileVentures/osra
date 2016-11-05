module CountryHelper
  def en_ar_country(country)
    en_country = ISO3166::Country[country]
    ar_country = I18n.with_locale :ar do
      I18n.t country, default: :missing
    end

    ("(#{en_country}) #{ar_country}").html_safe
  end

  def country_options_for_select
    Sponsor.distinct.pluck(:country).each_with_object({}) do |c, h|
      h[ISO3166::Country[c].name] = c
    end
  end
end
