require 'rails_helper'

RSpec.describe Hq::SponsorsController, type: :controller do
  let(:sponsorships_active) {build_stubbed_list :sponsorship, 3, active: true}
  let(:sponsorships_inactive) {build_stubbed_list :sponsorship, 2, active: false}
  let(:sponsor_with_sponsorships) {build_stubbed :sponsor, sponsorships: (sponsorships_active + sponsorships_inactive)}
  let(:sponsor) {build_stubbed :sponsor}
  let(:sponsors) {build_stubbed_list :sponsor, 2}

  before :each do
    sign_in instance_double(AdminUser)
  end

  describe '#index' do
    specify "without filters" do
      allow(Sponsor).to receive(:filter).and_return Sponsor
      expect(Sponsor).to receive(:paginate).with(page: "1").and_return sponsors
      get :index, page: 1
      expect(assigns(:filters).empty?).to be true
      expect(assigns(:sponsors)).to eq sponsors
      expect(response).to render_template 'index'
    end

    specify "Filter" do
      filter = build :sponsor_filter
      expect(Sponsor).to receive_message_chain(:filter, :column_sort, :paginate).and_return( sponsors )
      get :index, {filters: filter, commit: "Filter"}

      filter.each_key do |k|
        expect(assigns(:filters)[k].to_s).to eq filter[k].to_s
      end

      expect(assigns(:sponsors)).to eq sponsors
      expect(response).to render_template 'index'
    end

    specify "Sort_by" do
      sort_by = {column: Sponsor.column_names.sample.to_s, direction: ["asc", "desc"].sample}
      expect(Sponsor).to receive_message_chain(:filter, :column_sort, :paginate).and_return( sponsors )
      get :index, {sort_by: {column: sort_by[:column], direction: sort_by[:direction]}}

      expect(assigns(:sort_by)["column"].to_s).to eq sort_by[:column].to_s
      expect(assigns(:sort_by)["direction"].to_s).to eq sort_by[:direction].to_s
      expect(assigns(:sortable)).to eq true
      expect(assigns(:sponsors)).to eq sponsors
      expect(response).to render_template 'index'
    end

    specify "Clear Filters" do
      get :index, {page: 1, commit: "Clear Filters"}
      expect(response).to redirect_to hq_sponsors_path
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
      expect(response).to redirect_to hq_sponsor_url(assigns :sponsor)
    end

    specify 'redirects to new when user clicks Create and Add Another' do
      post :create, sponsor: build(:sponsor).attributes,
        commit: 'Create and Add Another'

      expect(response).to redirect_to new_hq_sponsor_path
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
      expect(response).to redirect_to hq_sponsor_url(sponsor)
    end

    specify 'unsuccessful' do
      expect(Sponsor).to receive(:find).and_return(sponsor)
      expect(sponsor).to receive(:save).and_return(false)
      put :update, id: sponsor.id, sponsor: sponsor.attributes
      expect(response).to render_template 'edit'
    end
  end

end
