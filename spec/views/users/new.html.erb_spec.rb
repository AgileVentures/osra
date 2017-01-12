require 'rails_helper' 

describe 'users/new.html.erb', type: :view do

  before :each do
    assign :user, build_stubbed(:user)
  end

  it 'renders the form partial' do
    render
    expect(view).to render_template(partial: '_form')
  end

  it 'cancel button goes to index page' do
    render
    expect(rendered).to have_link('Cancel', href: users_path)
  end

end
