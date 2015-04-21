require 'rails_helper'

RSpec.describe "hq/orphans/show.html.erb", type: :view do
  let(:orphan) { FactoryGirl.build_stubbed(:orphan) }

  describe 'the orphan exists' do
    before :each do
      assign(:orphan, orphan)
      render
    end

    it 'should have an Edit Orphan button' do
      expect(rendered).to have_link('Edit Orphan', edit_hq_orphan_path(orphan.id))
    end
  end

end
