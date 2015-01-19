module ApplicationHelper
  FULL_DATE_FORMAT_STRING= '%d %B %Y'
  MONTH_YEAR_DATE_FORMAT_STRING= '%m/%Y'

  def format_full_date(date)
    (date || NullDate.new).strftime(FULL_DATE_FORMAT_STRING)
  end

  def format_month_year_date(date)
    (date || NullDate.new).strftime(MONTH_YEAR_DATE_FORMAT_STRING)
  end

  def en_ar_country(country)
    en_country = ISO3166::Country[country]
    ar_country = I18n.with_locale :ar do
      t country, default: :missing
    end

    ("(#{en_country}) #{ar_country}").html_safe
  end
end
