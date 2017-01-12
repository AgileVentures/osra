require 'rails_helper'

RSpec.describe SponsorsController, type: :controller do
  let(:sponsorships_active) {build_stubbed_list :sponsorship, 3, active: true}
  let(:sponsorships_inactive) {build_stubbed_list :sponsorship, 2, active: false}
  let(:sponsor_with_sponsorships) {build_stubbed :sponsor, sponsorships: (sponsorships_active + sponsorships_inactive)}
  let(:sponsor) {build_stubbed :sponsor}
  let(:sponsors) {build_stubbed_list :sponsor, 2}

  before :each do
    sign_in instance_double(AdminUser)
  end

  describe '#index' do
    let(:sponsor_double) { double(Sponsor) }

    specify "without filters" do
      expect(Sponsor).to receive(:filter).and_return(sponsor_double)
      allow(sponsor_double).to receive_message_chain(:order,:paginate).and_return(sponsors)

      get :index, page: 1

      expect(assigns(:filters).empty?).to be true
      expect(assigns(:sponsors)).to eq sponsors
      expect(response).to render_template 'index'
    end

    specify "Filter" do
      filter = build :sponsor_filter
      expect(Sponsor).to receive(:filter).and_return(sponsor_double)
      allow(sponsor_double).to receive_message_chain(:order,:paginate).and_return(sponsors)

      get :index, {filters: filter, commit: "Filter"}

      filter.each_key do |k|
        expect(assigns(:filters)[k].to_s).to eq filter[k].to_s
      end
      expect(assigns(:sponsors)).to eq sponsors
      expect(response).to render_template 'index'
    end

    specify "Filter-CSV" do
      filter = build :sponsor_filter
      expect(Sponsor).to receive(:filter).and_return(sponsor_double)
      allow(sponsor_double).to receive_message_chain(:order,:paginate).and_return(sponsors)
      expect(Sponsor).to receive(:to_csv).and_return(sponsor_double)
      expect(@controller).to receive(:send_data) {
        @controller.render nothing: true
      }

      get :index, format: :csv, filters: filter

      filter.each_key do |k|
        expect(assigns(:filters)[k].to_s).to eq filter[k].to_s
      end
    end


    specify 'column_sort' do
      allow(Sponsor).to receive(:filter).and_return(sponsor_double)
      expect(sponsor_double).to receive(:order).with("name desc").and_return(sponsor_double)
      allow(sponsor_double).to receive(:paginate).and_return(sponsors)

      get :index, sort_column: "name", sort_direction: "desc"

      expect(assigns(:current_sort_column)).to eq :name
      expect(assigns(:current_sort_direction)).to eq "desc"
      expect(assigns(:sponsors)).to eq sponsors
    end

    specify "Clear Filters" do
      get :index, {page: 1, commit: "Clear Filters"}
      expect(response).to redirect_to sponsors_path
    end
  end

  specify '#show' do
    expect(Sponsor).to receive(:find).and_return(sponsor_with_sponsorships)
    expect(Sponsorship).to receive(:where).and_return(sponsorships_active + sponsorships_inactive)
    get :show, id: sponsor_with_sponsorships.id

    expect(assigns(:sponsor)).to eq sponsor_with_sponsorships
    expect(assigns(:sponsorships_active)).to eq sponsorships_active
    expect(assigns(:sponsorships_inactive)).to eq sponsorships_inactive
    expect(response).to render_template 'show'
  end

  specify '#new' do
    sponsor_new = Sponsor.new
    expect(Sponsor).to receive(:new).and_return(sponsor_new)
    get :new
    expect(assigns(:sponsor)).to be_a_new(Sponsor)
    expect(response).to render_template 'new'
  end

  context '#create' do
    specify 'successful' do
      post :create, sponsor: build(:sponsor).attributes
      expect(response).to redirect_to sponsor_url(assigns :sponsor)
    end

    specify 'redirects to new when user clicks Create and Add Another' do
      post :create, sponsor: build(:sponsor).attributes,
        commit: 'Create and Add Another'

      expect(response).to redirect_to new_sponsor_path
    end

    specify 'unsuccessful' do
      expect_any_instance_of(Sponsor).to receive(:save).and_return(false)
      post :create, sponsor: build(:sponsor).attributes
      expect(response).to render_template 'new'
    end
  end

  specify '#edit' do
    expect(Sponsor).to receive(:find).and_return(sponsor)
    get :edit, id: sponsor.id
    expect(assigns(:sponsor)).to eq sponsor
    expect(response).to render_template 'edit'
  end

  context '#update' do
    specify 'successful' do
      expect(Sponsor).to receive(:find).and_return(sponsor)
      expect(sponsor).to receive(:save).and_return(true)
      put :update, id: sponsor.id, sponsor: sponsor.attributes
      expect(response).to redirect_to sponsor_url(sponsor)
    end

    specify 'unsuccessful' do
      expect(Sponsor).to receive(:find).and_return(sponsor)
      expect(sponsor).to receive(:save).and_return(false)
      put :update, id: sponsor.id, sponsor: sponsor.attributes
      expect(response).to render_template 'edit'
    end
  end

end
