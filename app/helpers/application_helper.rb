module ApplicationHelper
  FULL_DATE_FORMAT_STRING= '%d %B %Y'
  MONTH_YEAR_DATE_FORMAT_STRING= '%m/%Y'

  def format_full_date(date)
    (date || NullDate.new).strftime(FULL_DATE_FORMAT_STRING)
  end

  def format_month_year_date(date)
    (date || NullDate.new).strftime(MONTH_YEAR_DATE_FORMAT_STRING)
  end

# sortable_column is a method used in views where the column header can be clicked to sort the records by that column
# This solution follows the railscast http://railscasts.com/episodes/228-sortable-table-columns
  def sortable_column(column, title = nil)
    title ||= column.titleize
    # if the same column is clicked twice, change the sort order from asc to desc or vice versa
    direction = column == params[:sort_by] && sort_direction == 'asc' ? 'desc' : 'asc'
    css_class = column == params[:sort_by] ? "sort-column-#{sort_direction}" : nil
    link_to title, { sort_by: column, direction: direction }, { class: css_class }
  end

end
