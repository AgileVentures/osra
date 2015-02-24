require 'rails_helper'

RSpec.describe "hq/orphans/show.html.haml", type: :view do
  describe 'the orphan exists' do
    before :each do
      @orphan = build_stubbed :orphan
      render
    end

    it 'should show the assigned orphan details' do
      expect(rendered).to match @orphan.name
    end

  end

end

