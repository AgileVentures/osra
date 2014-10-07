require 'rails_helper'
include Devise::TestHelpers

describe Admin::OrphansController, type: :controller do

  let(:orphan) { instance_double Orphan }

  before(:each) do
    sign_in instance_double(AdminUser)

    allow(Orphan).to receive(:new).and_return orphan
    allow(orphan).to receive(:build_original_address)
    allow(orphan).to receive(:build_current_address)

    get :new
  end

  describe 'new' do

    it 'calls Orphan.new' do
      expect(Orphan).to have_received :new
    end

    it 'assigns instance variables' do
      expect(assigns :orphan).to eq orphan
    end

    it 'calls build_current_address & #build_original_address on orphan' do
      expect(orphan).to have_received :build_current_address
      expect(orphan).to have_received :build_original_address
    end
  end
end
