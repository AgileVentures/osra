require 'spec_helper'

describe 'visiting the homepage', :pending=> true do
  before do
    visit '/'
  end

  it 'should have a body' do
    page.should have_css('body')    
  end
end
