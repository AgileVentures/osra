require 'rails_helper'

describe 'visiting the homepage', type: :request do
  before do
    get_via_redirect '/'
  end

  it 'should show the login page' do
    expect(response.body).to include('Log in')
  end
end
