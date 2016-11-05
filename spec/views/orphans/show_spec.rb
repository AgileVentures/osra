require 'rails_helper'

RSpec.describe "orphans/show.html.erb", type: :view do
  let(:orphan) { FactoryGirl.create(:orphan) }

  describe 'the orphan exists' do
    before :each do
      assign(:orphan, orphan)
      render
    end

    it 'should have an Edit Orphan button' do
      expect(rendered).to have_link('Edit Orphan', edit_orphan_path(orphan.id))
    end
    
    it 'should have partner field' do
      expect(rendered).to have_selector("dd", text: orphan.partner.name)
    end
  end
  
end
