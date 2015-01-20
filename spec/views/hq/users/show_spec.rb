require 'rails_helper'

RSpec.describe 'hq/users/show.html.erb', type: :view do
  describe 'user' do
    let(:user) { FactoryGirl.build_stubbed :user }

    before :each do
      assign :user, user
      render
    end

    describe 'displays' do
      specify 'user name' do
        expect(rendered).to match user.user_name
      end

      specify 'email address' do
        expect(rendered).to match user.email
      end
    end
  end

  specify 'with no active nor inactive sponsors' do
    assign :user, FactoryGirl.build_stubbed(:user)
    render

    expect(view).to_not render_template partial: 'hq/sponsors/index.html.haml',
                                      locals: {sponsors: []}
  end

  describe 'with sponsors' do
    let!(:user) { FactoryGirl.build_stubbed :user }
    let!(:sponsors) do
      [ FactoryGirl.create(:sponsor, agent: user, status: Status.find_by_name('Active')),
        FactoryGirl.create(:sponsor, agent: user, status: Status.find_by_name('On Hold')),
        FactoryGirl.create(:sponsor, agent: user, status: Status.find_by_name('Inactive'))
      ]
    end

    before :each do
      assign :user, user
      render
    end

    specify 'inactive' do
      expect(view).to render_template partial: 'hq/sponsors/index.html.haml',
                                      locals: {sponsors: user.sponsors.all_active}
    end

    specify 'active' do
      expect(view).to render_template partial: 'hq/sponsors/index.html.haml',
                                      locals: {sponsors: user.sponsors.all_inactive}
    end
  end
end
