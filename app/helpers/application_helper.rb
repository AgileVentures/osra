module ApplicationHelper
  def sortable_link(sort_column, options = {})
    options.reverse_merge!({
          sort_direction: nil,
          table_header: nil,
          sort_columns_included_resource: nil,
          sort_column_is_active: false
         })
    options[:table_header] ||= sort_column.titleize

    link_direction = nil

    if options[:sort_column_is_active]
      link_direction = invert_sort_direction_of(options[:sort_direction])
      icon = "<span class=\"glyphicon th_sort_#{link_direction}\"></span>"
    else
      icon = "<div class='asc_desc'>" +
              "<span class=\"glyphicon th_sort_asc\"></span>" +
              "<span class=\"glyphicon th_sort_desc\"></span>" +
             "</div>"
    end

    query_params = request.query_parameters.merge({
      :sort_column => sort_column,
      :sort_direction => link_direction,
      :sort_columns_included_resource => options[:sort_columns_included_resource]
    })
    th_link = link_to options[:table_header], query_params

    return (th_link + icon.html_safe)
  end

private

  def invert_sort_direction_of direction
    (direction == "asc") ? "desc" : "asc"
  end
end
