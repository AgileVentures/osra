require 'spec_helper'

describe 'visiting the homepage' do
  before do
    get '/'
  end

  it 'should show the login page' do
    debugger
    response.should have_text('Osra login')
  end
end
