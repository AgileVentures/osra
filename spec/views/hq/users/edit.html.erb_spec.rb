require 'rails_helper' 

describe 'hq/users/edit.html.erb', type: :view do

  before :each do
    assign :user, build_stubbed(:user)
  end

  it 'renders the form partial' do
    render
    expect(view).to render_template(partial: '_form')
  end

end
