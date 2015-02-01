require 'rails_helper'

RSpec.describe 'layouts/application.html.erb', type: :view do
  describe 'renders' do
    specify 'navigation' do
      render and expect(view).to render_template 'layouts/navigation'
    end
  end
end
