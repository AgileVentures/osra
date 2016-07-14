require 'rails_helper'

RSpec.describe Hq::OrphansController, type: :controller do
  let(:orphans) {build_stubbed_list(:orphan, 2)}
  let(:orphan) {build_stubbed :orphan}
  let(:statuses) { [] }
  let(:sponsorship_statuses) { [] }
  let(:provinces) {instance_double Province}

  before :each do
    sign_in instance_double(AdminUser)
  end

  describe '#index' do
    let(:orphan_double) { double(Orphan) }

    specify "without filters" do
      expect(Orphan).to receive(:filter).and_return(orphan_double)
      allow(orphan_double).to receive_message_chain(:includes,:order,:paginate).and_return(orphans)

      get :index, page: 1

      expect(assigns(:filters).empty?).to be true
      expect(assigns(:orphans)).to eq orphans
      expect(response).to render_template 'index'
    end

    specify "Filter" do
      filter = build :orphan_filter

      expect(Orphan).to receive(:filter).and_return(orphan_double)
      allow(orphan_double).to receive_message_chain(:includes,:order,:paginate).and_return(orphans)

      get :index, {page: 1, filters: filter, commit: "Filter"}

      filter.each_key do |k|
        expect(assigns(:filters)[k].to_s).to eq filter[k].to_s
      end
      expect(assigns(:orphans)).to eq orphans
      expect(response).to render_template 'index'
    end

    specify "Clear Filters" do
      get :index, {page: 1, commit: "Clear Filters"}

      expect(response).to redirect_to hq_orphans_path
    end

    specify 'column_sort' do
      allow(Orphan).to receive(:filter).and_return(orphan_double)
      expect(orphan_double).to receive(:includes).with(:orphan_list).and_return(orphan_double)
      expect(orphan_double).to receive(:order).with("partners.name desc").and_return(orphan_double)
      allow(orphan_double).to receive(:paginate).and_return(orphans)

      get :index, sort_column: "partners.name", sort_direction: "desc", sort_columns_included_resource: "orphan_list"

      expect(assigns(:current_sort_column)).to eq :"partners.name"
      expect(assigns(:current_sort_direction)).to eq "desc"
      expect(assigns(:orphans)).to eq orphans
    end
  end

  specify '#show' do
    expect(Orphan).to receive(:find).with(orphan.id.to_s).and_return(orphan)
    get :show, id: orphan.id

    expect(assigns(:orphan)).to eq orphan
    expect(assigns(:sponsor)).to eq orphan.current_sponsor
    expect(response).to render_template 'show'
  end

  context '#edit and #update' do
    before :each do
      expect(Orphan).to receive(:find).with(orphan.id.to_s).and_return(orphan)
    end

    specify 'editing renders the edit view' do
      expect(Orphan).to receive_message_chain(:statuses, :keys, :map).
        and_return(statuses)
      expect(Orphan).to receive_message_chain(:sponsorship_statuses, :keys, :map).
        and_return(sponsorship_statuses)
      expect(Province).to receive(:all).and_return(provinces)
      get :edit, id: orphan.id

      expect(assigns(:orphan)).to eq orphan
      expect(assigns(:statuses)).to eq statuses
      expect(assigns(:sponsorship_statuses)).to eq sponsorship_statuses
      expect(assigns(:provinces)).to eq provinces
      expect(response).to render_template 'edit'
    end

    specify 'successful update redirects to the show view' do
      expect(orphan).to receive(:save).and_return(true)
      patch :update, id: orphan.id, orphan: { name: 'John' }

      expect(response).to redirect_to(hq_orphan_path(orphan))
      expect(flash[:success]).to_not be_nil
    end

    specify 'unsuccessful update renders the edit view' do
      expect(Orphan).to receive_message_chain(:statuses, :keys, :map).
        and_return(statuses)
      expect(Orphan).to receive_message_chain(:sponsorship_statuses, :keys, :map).
        and_return(sponsorship_statuses)
      expect(Province).to receive(:all).and_return(provinces)
      expect(orphan).to receive(:save).and_return(false)
      patch :update, id: orphan.id, orphan: { name: 'John' }

      expect(assigns(:orphan)).to eq orphan
      expect(assigns(:statuses)).to eq statuses
      expect(assigns(:sponsorship_statuses)).to eq sponsorship_statuses
      expect(assigns(:provinces)).to eq provinces
      expect(response).to render_template 'edit'
      expect(flash[:success]).to be_nil
    end
  end
end
