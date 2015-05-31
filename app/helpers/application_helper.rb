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
end
