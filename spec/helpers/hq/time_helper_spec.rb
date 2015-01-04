require 'rails_helper'

RSpec.describe Hq::TimeHelper, type: :helper do
  it 'formats a date' do
    expect(Hq::TimeHelper.date_to_string(Date.current)).to be_a_kind_of String
  end

  it "doesn't raise exception on nil" do
    expect(Hq::TimeHelper.date_to_string(nil)).to eq nil
  end
end
