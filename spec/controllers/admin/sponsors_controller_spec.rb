require 'rails_helper'
include Devise::TestHelpers

RSpec.describe Admin::SponsorsController, :type => :controller do

  let(:sponsor) { instance_double Sponsor }
  before(:each) { sign_in instance_double AdminUser }

  describe '#create' do

    before(:each) { allow(Sponsor).to receive(:new).and_return(sponsor) }

    context 'when successful' do

      before(:each) { allow(sponsor).to receive(:save).and_return(true) }

      it 'redirects to created sponsor if user clicks Create Sponsor' do
        post :create, sponsor: {}, commit: 'Submit'

        expect(response).to redirect_to admin_sponsor_path(sponsor)
        expect(flash[:success]).to eq 'Sponsor was successfully created'
      end

      it 'redirects to new if user clicks Create and Add Another' do
        post :create, sponsor: {}, commit: 'Create and Add Another'

        expect(response).to redirect_to new_admin_sponsor_path
        expect(flash[:success]).to eq 'Sponsor was successfully created'
      end
    end

    context 'when unsuccessful' do

      before(:each) { allow(sponsor).to receive(:save).and_return(false) }

      it 'renders new' do
        post :create, sponsor: {}, commit: 'Submit'

        expect(response).to render_template 'new'
      end
    end
  end
end
