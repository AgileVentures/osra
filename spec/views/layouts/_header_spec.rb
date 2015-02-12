require 'rails_helper'
include Devise::TestHelpers

RSpec.describe 'layouts/_header.html.erb', type: :view do
  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:admin_user]
    @admin = FactoryGirl.create :admin_user
    sign_in @admin
  end

  it 'should show header information' do
    render
    expect(rendered).to have_link(@admin.email, href: admin_admin_user_path(@admin.id))
    expect(rendered).to have_link('logout', href: destroy_admin_user_session_path)
  end
end
