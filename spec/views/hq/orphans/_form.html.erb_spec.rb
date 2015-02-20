require 'rails_helper'
require 'cgi'

RSpec.describe "hq/orphans/_form.html.erb", type: :view do
  let(:orphan) { build_stubbed :orphan }

  before :each do
    assign(:orphan, orphan)
  end

  specify 'has a form' do
    render

    assert_select 'form'
  end

  describe '"Cancel" button' do
    specify 'when no :id' do
      allow(orphan).to receive(:id).and_return nil
      render

      assert_select 'a[href=?]', hq_orphans_path, text: 'Cancel'
    end

    specify 'when :id' do
      allow(orphan).to receive(:id).and_return 42
      render

      assert_select 'a[href=?]', hq_orphan_path(42), text: 'Cancel'
    end
  end

  specify 'form values' do
    #TODO which fields do we need here?
  end
end

