require 'rails_helper'

RSpec.describe 'hq/users/show.html.erb', type: :view do
  describe 'users' do
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

  [['active', 'Active'], ['active', 'On Hold'], ['inactive', 'Inactive']].each do |status|
    describe "#{status[0]} (#{status[1]}) sponsors" do
      describe "don't exist" do
        let!(:user) { FactoryGirl.build_stubbed :user }

        before :each do
          assign :user, user
          render
        end

        specify "don't display" do
          assert_select 'div[class=?]', "#{status[0]}_sponsors_index", false
        end

        specify 'total number' do
          expect(rendered).to match /0 #{status[0].titlecase} Sponsors/
        end
      end

      eval %Q[
        describe 'exist' do
          let!(:user) { FactoryGirl.build_stubbed :user }
          let(:an_#{status[0]}_status) { Status.find_by_name '#{status[1]}' }
          let!(:#{status[0]}_sponsor) { FactoryGirl.create(:sponsor, status: an_#{status[0]}_status, agent: user) }

          before :each do
            assign :user, user
            render
          end

          describe 'display' do
            specify 'total number' do
              expect(rendered).to match /1 #{status[0].titlecase} Sponsor/
            end

            ['osra_num', 'name', 'status.name', 'sponsor_type.name'].each do |attrib|
              eval %Q[
                specify attrib do
                  assert_select 'div[class=?]', "#{status[0]}_sponsors_index" do |elements|
                    assert_select 'td', text: #{status[0]}_sponsor.\#{attrib}
                  end
                end
              ]
            end

            specify "link to #{status[0]} sponsor" do
              expect(rendered).to have_link(#{status[0]}_sponsor.osra_num,
                                            hq_sponsor_path(#{status[0]}_sponsor))
            end
          end
        end
      ]
    end
  end


end
