require 'rails_helper' 

describe 'users/edit.html.erb', type: :view do

  before :each do
    @user = build_stubbed(:user)
    assign(:user, @user)
  end

  it 'renders the form partial' do
    render
    expect(view).to render_template(partial: '_form')
  end

  it 'cancel button goes to show page' do
    render
    expect(rendered).to have_link('Cancel', href: user_path(@user))
  end

end
