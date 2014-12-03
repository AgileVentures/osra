require 'rails_helper'

describe PartnersController, type: :controller do

  describe 'POST #create' do
    context 'valid partner' do
      it 'redirects to #show' do
        post :create, partner: {name: 'Partner1', province_id: Province.first.id}
        expect(response).to redirect_to admin_partner_path(Partner.find_by name: 'Partner1')
      end
    end
    context 'invalid partner' do
      it 'redirects to #index' do
        post :create, partner: {name: 'Partner2', province_id: nil}
        expect(response).to redirect_to admin_partners_path
      end
    end
  end

  describe "GET #index" do
    before :each do
      3.times do
        FactoryGirl.create :partner, province: Province.first
      end
    end

    it "populates an array of partners" do
      partners= Partner.all
      get :index
      expect(assigns(:partners)).to match_array partners
    end

    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before :each do
      FactoryGirl.create :partner, name: 'ActivePartner', status: Status.find_by_name('Active'),
                          province: Province.first
      FactoryGirl.create :partner, name: 'InactivePartner', status: Status.find_by_name('Inactive'),
                          province: Province.first
    end

    context 'any partner' do
      let(:partner) { Partner.first }

      it "populates a partner" do
        get :show, id: partner.id
        expect(assigns(:partner)).to eq partner
      end

      it "renders the :show view" do
        get :show, id: partner.id
        expect(response).to render_template :show
      end

      it 'shows the Edit button' do
        get :show, id: partner.id
        expect(assigns(:action_item_links).to_a.compact*('')).to match /Edit Partner/
      end

      context 'with list' do
        before :each do allow(OrphanList).to receive(:find_by).and_return(true) end

        it 'shows a list' do
          get :show, id: partner.id
          expect(assigns(:list)).to eq true
        end
      end

      context 'without list' do
        before :each do allow(OrphanList).to receive(:find_by).and_return(nil) end

        it 'hides a list' do
          get :show, id: partner.id
          expect(assigns(:list)).to eq false
        end
      end
    end

    context 'for active partner' do
      let(:partner) { Partner.find_by name: 'ActivePartner' }

      it 'shows the Upload button' do
        get :show, id: partner.id
        expect(assigns(:action_item_links).to_a.compact*('')).to match /Upload Orphan List/
      end
    end

    context 'for inactive partner' do
      let(:partner) { Partner.find_by name: 'InactivePartner' }

      it 'hides the Upload button' do
        get :show, id: partner.id
        expect(assigns(:action_item_links).to_a.compact*('')).to_not match /Upload Orphan List/
      end
    end
  end

  describe 'GET #new' do
    it "populates an empty partner" do
      get :new
      expect(assigns(:partner)).to have_same_attributes_as Partner.new
    end

    it "doesn't set edit flag" do
      get :new
      expect(assigns(:edit)).to_not eq true
    end
  end

  describe 'GET #edit' do
    before :each do
      FactoryGirl.create :partner, name: 'Partner1', status: Status.find_by_name('Active'),
                          province: Province.first
    end
    it "populates the partner" do
      get :edit, id: Partner.first.id
      expect(assigns(:partner)).to have_same_attributes_as Partner.first
    end

    it 'sets edit flag' do
      get :edit, id: Partner.first.id
      expect(assigns(:edit)).to eq true
    end
  end

  describe 'POST #update' do
    before :each do
      FactoryGirl.create :partner, name: 'Partner1', status: Status.find_by_name('Active'),
                          province: Province.first
    end

    it 'redirects to GET#show' do
      post :update, id: Partner.first.id, partner: {name: 'notPartner1'}
      expect(response).to redirect_to admin_partner_path(Partner.first.id)
    end

    context 'invalid partner' do
      it 'discards changes' do
        post :update, id: Partner.first.id, partner: {province: nil}
        expect(Partner.first.province).to_not be_nil
      end
    end

    context 'valid partner' do
      it 'saves the record' do
        post :update, id: Partner.first.id, partner: {name: 'something_new'}
        expect(Partner.first.name).to eq 'something_new'
      end
    end
  end


end
