require 'rails_helper'

describe PartnersController, type: :controller do
  before :each do
    sign_in instance_double(AdminUser)
  end

  describe "GET #index" do
    before :each do
      3.times do
        FactoryGirl.create :partner, province: Province.first
      end
    end

    it "sends a paginated array" do
      allow(Partner).to receive(:paginate).with(page: '2', per_page: '3').and_return(['foo', 'bar', 'now'])
      get :index, page: 2, per_page: 3
      expect(assigns(:partners)).to match_array (['foo', 'bar', 'now'])
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

end
