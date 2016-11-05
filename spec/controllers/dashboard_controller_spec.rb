require 'rails_helper'

RSpec.describe DashboardController, type: :controller do

  describe "GET #index view" do
    before(:each) do
      sign_in instance_double(AdminUser)
    end

    it "renders the :index view" do
      get :index

      expect(response).to render_template 'index'
    end
  end
end
