module WillPaginateHelper

  def will_paginate_render_options
    {
      inner_window: 2,
      outer_window: 0,
      renderer: BootstrapPagination::Rails
    }
  end

  def render_options_with_custom_param(param_name)
    will_paginate_render_options.merge(param_name: param_name)
  end

end
