require 'rails_helper'

describe "hq/users/_form.html.erb", type: :view do

  before :each do
    @user = FactoryGirl.build_stubbed(:user)
    render partial: 'form', locals: { cancel_path: 'some cancel url' }
  end

  it 'has a form element' do
    expect(rendered).to have_selector('form')
  end

  it 'has an input for user name, prefilled with current value' do
    expect(rendered).to have_selector("input\#user_user_name[value=\"#{@user.user_name}\"]")
  end

  it 'has an input for email address, prefilled with current value' do
    expect(rendered).to have_selector("input\#user_email[value=\"#{@user.email}\"]")
  end

  it 'has a submit button' do
    expect(rendered).to have_selector('input[type="submit"]')
  end

  it 'has a cancel button' do
    expect(rendered).to have_link('Cancel', href: 'some cancel url')
  end

  it 'marks required fields' do
    validated_attributes = User.new.attributes.keys.select do |attr|
      (User.validators_on(attr).map(&:class) & PRESENCE_VALIDATORS).present?
    end

    validated_attributes.each do |attr|
      expect(rendered).
        to have_selector("label.required_field[for=\"user_#{attr}\"]")
    end
  end

end
