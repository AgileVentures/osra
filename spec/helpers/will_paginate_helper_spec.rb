require 'rails_helper'

RSpec.describe WillPaginateHelper, type: :helper do

  describe '#render_options_with_custom_param' do 
    it "returns hash of options with 'param_name' key" do
      allow(helper).to receive(:will_paginate_render_options).and_return({})

      expect(helper.render_options_with_custom_param('check me')).
        to include(param_name: 'check me')
    end
  end
end
