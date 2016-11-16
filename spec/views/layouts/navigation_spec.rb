require 'rails_helper'

RSpec.describe 'layouts/_navigation.html.erb', type: :view do
  describe 'nav button count' do
    before :each do
      allow(view).to receive_message_chain(:request, :path, :=~).and_return(nil)
      allow(view).to receive_message_chain(:request, :path, :=~).
                  with(ApplicationController::NAVIGATION_BUTTONS.sample[:path_regex]).
                  and_return(true)
      render
    end

    specify 'one higlighted' do
      expect(rendered).to have_selector('div.no-horiz-padding>ul>li.active', count: 1)
      expect(rendered).to have_selector('div.no-horiz-padding>ul>li.dormant', count: (ApplicationController::NAVIGATION_BUTTONS.count - 1))
    end
  end

  describe 'buttons' do
    specify 'has glyph icon' do
      stub_const('ApplicationController::NAVIGATION_BUTTONS', [
        { text: 'foobar', href: '"/pathname/file.extension"', path_regex: /baz/, glyph: 'lorem_ipsum' } ])
      render

      expect(rendered).to have_selector('li span.glyphicon')
      expect(rendered).to have_selector('li span.lorem_ipsum')
    end

    specify 'generates link from href code' do
      stub_const('ApplicationController::NAVIGATION_BUTTONS', [
        { text: 'foobar', href: '"/pathname/file.extension".reverse', path_regex: /baz/, glyph: 'lorem_ipsum' } ])
      render

      expect(rendered).to have_link("foobar", "noisnetxe.elif/emanhtap/")
    end
  end
end
