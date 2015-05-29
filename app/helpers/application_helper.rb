module ApplicationHelper
  FULL_DATE_FORMAT_STRING= '%d %B %Y'
  MONTH_YEAR_DATE_FORMAT_STRING= '%m/%Y'

  def format_full_date(date)
    (date || NullDate.new).strftime(FULL_DATE_FORMAT_STRING)
  end

  def format_month_year_date(date)
    (date || NullDate.new).strftime(MONTH_YEAR_DATE_FORMAT_STRING)
  end

  def set_sort_by_direction current_column, sort_by_params
    if (current_column.to_sym == sort_by_params["column"].to_sym && sort_by_params["direction"].to_sym != :desc)
      return :desc
    else
      return :asc
    end

  rescue #for undefind arguments
    return :asc
  end

end
