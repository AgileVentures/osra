require 'rails_helper'

RSpec.describe "sponsors/_form.html.haml", type: :view do
  let(:user) { build_stubbed :user}
  let(:sponsor_full) do
    build_stubbed :sponsor_full, agent: user,
                   request_fulfilled: [true, false].sample
  end
  let(:sponsor_new) { Sponsor.new }

  def render_sponsor_form current_sponsor
    render partial: 'sponsors/form.html.haml',
                          locals: { sponsor: current_sponsor,
                                    statuses: Status.all,
                                    sponsor_types: SponsorType.all,
                                    organizations: Organization.all,
                                    branches: Branch.all,
                                    cities: [sponsor_full.city].
                                              unshift(Sponsor::NEW_CITY_MENU_OPTION)
                                  }
  end

  specify 'has a form' do
    render_sponsor_form sponsor_new

    expect(rendered).to have_selector("form")
  end

  describe 'has a "Cancel" button' do
    specify 'using an existing Sponsor record' do
      render_sponsor_form sponsor_full

      expect(rendered).to have_link("Cancel", sponsor_path(sponsor_full))
    end

    specify 'using a new Sponsor record' do
      render_sponsor_form sponsor_new

      expect(rendered).to have_link("Cancel", sponsors_path)
    end
  end

  describe 'has form values' do
    specify 'using an existing Sponsor record' do
      allow(User).to receive(:pluck).and_return([[user.user_name, user.id]])
      render_sponsor_form sponsor_full

      #textfields
      ["name", "requested_orphan_count", "start_date", "new_city_name", "address", "email",
       "contact1", "contact2", "additional_info"].each do |field|
        if sponsor_full[field]
          expect(rendered).to have_selector("input[id='sponsor_#{field}'][value=\"#{sponsor_full[field].to_s}\"]")
        else
          expect(rendered).to have_selector("input[id='sponsor_#{field}']")
          expect(rendered).to_not have_selector("input[id='sponsor_#{field}'][value]")
        end
      end

      expect(rendered).to have_select("Status", selected: sponsor_full.status.name, options: Status.pluck(:name))

      expect(rendered).to have_select("Gender", selected: sponsor_full.gender, options: Settings.lookup.gender)

      if sponsor_full.request_fulfilled
        expect(rendered).to have_checked_field("Request fulfilled", disabled: true)
      else
        expect(rendered).to have_unchecked_field("Request fulfilled", disabled: true)
      end

      expect(rendered).to have_select("sponsor_sponsor_type_id", selected: sponsor_full.sponsor_type.name,
                                       options: SponsorType.pluck(:name), disabled: true)

      expect(rendered).to have_selector("select[id='sponsor_organization_id'][disabled]")
      if sponsor_full.organization
        expect(rendered).to have_selector("select[id='sponsor_organization_id'] option[selected]", text: sponsor_full.organization.name)
      else
        expect(rendered).to have_selector("select[id='sponsor_organization_id'] option", text: "")
        expect(rendered).to_not have_selector("select[id='sponsor_organization_id'] option[selected]")
      end

      expect(rendered).to have_selector("select[id='sponsor_branch_id'][disabled]")
      if sponsor_full.branch
        expect(rendered).to have_selector("select[id='sponsor_branch_id'] option[selected]", text: sponsor_full.branch.name)
      else
        expect(rendered).to have_selector("select[id='sponsor_branch_id'] option", text: "")
        expect(rendered).to_not have_selector("select[id='sponsor_branch_id'] option[selected]")
      end

      expect(rendered).to have_select("sponsor_payment_plan", selected: sponsor_full.payment_plan,
                                       with_options: Sponsor::PAYMENT_PLANS)

      expect(rendered).to have_select("Country", selected: en_ar_country(sponsor_full.country))

      expect(rendered).to have_select("City", selected: sponsor_full.city)

      expect(rendered).to have_selector("select[id='sponsor_agent_id'] option[selected]", text: sponsor_full.agent.user_name)

      expect(rendered).to have_selector("input[type='submit'][value='Update Sponsor']")
    end

    specify "using a new Sponsor record" do
      render_sponsor_form sponsor_new

      expect(rendered).to have_selector("input[id='sponsor_name']")
      expect(rendered).to_not have_selector("input[id='sponsor_name'][value]")

      expect(rendered).to_not have_selector("input[id='sponsor_request_fulfilled']")

      #selects that are disabled only for an existing record
      ["sponsor_type", "organization", "branch"].each do |field|
        expect(rendered).to have_selector("select[id='sponsor_#{field}_id']")
        expect(rendered).to_not have_selector("select[id='sponsor_#{field}_id'][disabled]")
      end
    end

    describe 'required fields' do
      before(:each) { render_sponsor_form sponsor_full }

      it 'marks required fields' do
        expect(rendered).to mark_required_fields_for Sponsor
      end

      it 'does not mark optional' do
        expect(rendered).not_to mark_optional_fields_for Sponsor
      end
    end
  end

end
