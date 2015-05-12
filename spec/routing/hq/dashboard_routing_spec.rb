require 'rails_helper'

RSpec.describe 'Hq::Dashboard routing', type: :routing do
  specify 'disposable spec', pending: 'be sure to route the default "/hq" route here once available' do
    expect(get: '/hq/dashboard').to be_routable
  end
end