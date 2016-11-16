module TimeHelper
  FULL_DATE_FORMAT_STRING= '%d %B %Y'
  MONTH_YEAR_DATE_FORMAT_STRING= '%m/%Y'

  def format_full_date(date)
    (date || NullDate.new).strftime(FULL_DATE_FORMAT_STRING)
  end

  def format_month_year_date(date)
    (date || NullDate.new).strftime(MONTH_YEAR_DATE_FORMAT_STRING)
  end
end
