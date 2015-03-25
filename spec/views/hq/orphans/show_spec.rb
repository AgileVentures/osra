require 'rails_helper'

RSpec.describe "hq/orphans/show.html.erb", type: :view do
  describe 'the orphan exists' do
    before :each do
      @orphan = build_stubbed :orphan
      render
    end

    it 'should show the assigned orphan details' do
      expect(rendered).to match @orphan.name
    end

    it 'should have an Edit Orphan button' do
      expect(rendered).to have_link('Edit Orphan', edit_hq_orphan_path(@orphan.id))
    end
  end

end
