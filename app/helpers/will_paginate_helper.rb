module WillPaginateHelper

  def will_paginate_render_options(options = {})
    {
      inner_window: 2,
      outer_window: 0,
      renderer: BootstrapPagination::Rails
    }.merge(options)
  end

end
