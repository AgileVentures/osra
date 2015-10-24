module WillPaginateHelper

  def will_paginate_render_options
    {
      inner_window: 2,
      outer_window: 0,
      renderer: BootstrapPagination::Rails
    }
  end

end