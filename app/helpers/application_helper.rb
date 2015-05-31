module ApplicationHelper
  FULL_DATE_FORMAT_STRING= '%d %B %Y'
  MONTH_YEAR_DATE_FORMAT_STRING= '%m/%Y'

  def sortable(column, title = nil)
  	title ||= column.titleize
  	css_class = column == sort_column ? "current #{sort_direction}" : nil
  	direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
  	link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def format_full_date(date)
    (date || NullDate.new).strftime(FULL_DATE_FORMAT_STRING)
  end

  def format_month_year_date(date)
    (date || NullDate.new).strftime(MONTH_YEAR_DATE_FORMAT_STRING)
  end

  #use in views for generating column header links and glyphicons
  #current_collumn: column_name of current table header
  #sort_by_params: a hash containing column and direction. e.g.: {"column":"name", "direction":"asc"}
  #Returns :asc or :desc based on if sorting is done on current_column and it's direction
  def get_sorting_direction current_column, sort_by_params
    if (current_column.to_sym == sort_by_params["column"].to_sym && sort_by_params["direction"].to_sym != :desc)
      return :desc
    else
      return :asc
    end

  rescue #for undefind arguments
    return :asc
  end

end
