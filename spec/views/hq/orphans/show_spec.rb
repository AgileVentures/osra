require 'rails_helper'

RSpec.describe "hq/orphans/show.html.haml", type: :view do
  let(:orphans) { FactoryGirl.build_stubbed(:orphan_list) }
  let(:orphan) { FactoryGirl.build_stubbed(:orphan, orphan_list: orphans) }

  describe 'the orphan exists' do
    before :each do
      assign(:orphan, orphan)
      render
    end

    it 'should show the assigned orphan details' do
      expect(rendered).to match orphan.name
    end

    it 'should have an Edit Orphan button' do
      expect(rendered).to have_link('Edit Orphan', edit_hq_orphan_path(orphan.id))
    end

  end

end

