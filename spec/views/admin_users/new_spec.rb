require 'rails_helper' 

describe 'admin_users/new.html.erb', type: :view do

  before :each do
    assign :admin_user, build_stubbed(:admin_user)
  end

  it 'renders the form, its fields and submit button' do
    render
    expect(view).to render_template(:new)
    expect(rendered).to have_selector("form")
    ["email", "password", "password_confirmation"].each do |field|
      expect(rendered).to have_selector("input[id='admin_user_#{field}']")
    end
    expect(rendered).to have_selector("input[type='submit'][value='Create Admin User']")
  end

  it 'has a cancel button going to the index page' do
    render
    expect(rendered).to have_link('Cancel', href: admin_users_path)
  end

end
