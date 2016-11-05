require 'rails_helper'

RSpec.describe "devise/sessions/new.html.erb", type: :view do
  let(:resource) {build_stubbed :admin_user}
  before :each do
    render template: subject,
            locals: {
                      resource: resource,
                      resource_name: :admin_user,
                      devise_mapping: Devise.mappings[:admin_user]
                    }
  end

  specify 'has a form' do
    expect(rendered).to have_selector("form")
  end

  specify 'form values' do
    expect(rendered).to have_field("Email")
    expect(rendered).to have_field("Password")
    expect(rendered).to have_unchecked_field("Remember me")
    expect(rendered).to have_selector("input[type='submit'][value='Log in']")
  end
end
