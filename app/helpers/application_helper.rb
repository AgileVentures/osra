module ApplicationHelper
  FULL_DATE_FORMAT_STRING= '%d %B %Y'
  MONTH_YEAR_DATE_FORMAT_STRING= '%m/%Y'

  def sortable_link(db_column, table_header = nil, includ = nil)
  	table_header ||= db_column.titleize
    icon = ''
  	direction = db_column == sort_column && sort_direction == "asc" ? "desc" : "asc"
  	link = link_to table_header, {:sort => db_column, :direction => direction, :includ => includ}
    icon = "<span class=\"glyphicon th_sort_#{sort_direction}\"></span>" if db_column == sort_column
    return(link + icon.html_safe)
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
