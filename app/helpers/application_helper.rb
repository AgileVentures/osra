module ApplicationHelper
  FULL_DATE_FORMAT_STRING= '%d %B %Y'
  MONTH_YEAR_DATE_FORMAT_STRING= '%m/%Y'

  def format_full_date(date)
    (date || NullDate.new).strftime(FULL_DATE_FORMAT_STRING)
  end

  def format_month_year_date(date)
    (date || NullDate.new).strftime(MONTH_YEAR_DATE_FORMAT_STRING)
  end

  def sortable_link(sort_column, options = {})
    options.reverse_merge!({
          sort_direction: nil,
          table_header: nil,
          sort_columns_included_resource: nil,
          sort_column_is_active: false
         })
    options[:table_header] ||= sort_column.titleize

    link_direction = nil
    icon = ''

    if options[:sort_column_is_active]
      link_direction = invert_sort_direction_of(options[:sort_direction])
      icon = "<span class=\"glyphicon th_sort_#{link_direction}\"></span>"
    end

    link = link_to options[:table_header], {:sort_column => sort_column, :sort_direction => link_direction, :sort_columns_included_resource => options[:sort_columns_included_resource]}

    return (link + icon.html_safe)
  end

  def invert_sort_direction_of direction
    (direction == "asc") ? "desc" : "asc"
  end
end
