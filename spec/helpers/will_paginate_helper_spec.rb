require 'rails_helper'

RSpec.describe WillPaginateHelper, type: :helper do

  describe '#will_paginate_render_options' do 
    context 'without input params' do
      it "returns hash of custom options" do
        expected_hash = {
          inner_window: 2,
          outer_window: 0,
          renderer: BootstrapPagination::Rails
        }

        expect(helper.will_paginate_render_options).to eq(expected_hash)
      end
    end

    context 'without hash input' do
      it "returns default hash of options with custom inputs" do
        expected_hash = {
          inner_window: 2,
          outer_window: 0,
          renderer: BootstrapPagination::Rails,
          param_name: 'test param'
        }

        expect(helper.will_paginate_render_options(param_name: 'test param')).
          to eq(expected_hash)
      end
    end
  end
end
