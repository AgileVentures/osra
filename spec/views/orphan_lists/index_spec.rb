require 'rails_helper'

RSpec.describe "orphan_lists/index.html.erb", type: :view do
  context 'partners exist' do
    let(:partner) {build_stubbed :partner}
    let(:orphan_lists) {build_stubbed_list :orphan_list, 3}

    describe "with orphan_lists" do
      before :each do
        assign(:partner, partner)
        assign(:orphan_lists, orphan_lists)
      end

      it 'should delegate to partials' do
        render

        expect(view).to render_template partial: 'layouts/_content_title.erb'
      end

      it "should display orphan lists" do
        render

        within "tbody" do
          expect(rendered).to have_selector('tr', count: 3)
          expect(rendered).to have_link('Download', count: 3)
        end
      end
    end

    describe "without orphan lists" do
      before :each do
        assign(:partner, partner)
        assign(:orphan_lists, [])
      end

      it 'should indicate no orphan lists were found' do
        render

        expect(rendered).to match /No Orphan Lists found/
      end
    end
  end

end
