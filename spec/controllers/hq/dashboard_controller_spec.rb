require 'rails_helper'

RSpec.describe Hq::DashboardController, type: :controller do

  describe "GET #index view" do
  	before(:each) do
    	sign_in instance_double(AdminUser)
  	end
  	it "renders the :index view" 
  end
end
