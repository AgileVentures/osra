require 'rails_helper'

RSpec.describe 'hq/sponsors/index.html.haml', type: :view do
  it 'should delegate to partial' do
    assign(:sponsors, [])
    render

    expect(view).to render_template partial: 'hq/sponsors/index.html.haml', locals: {sponsors: []}
  end
end
