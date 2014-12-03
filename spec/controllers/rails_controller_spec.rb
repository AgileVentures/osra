require 'rails_helper'

describe RailsController, type: :controller do

  describe 'link_to' do
    before :each do
      allow(ActionController::Base.helpers).to receive(:link_to).and_return('success')
    end

    it 'delegates the call' do
      expect(RailsController.new.link_to 'arg1').to eq 'success'
    end
  end

  describe 'constants' do
    context 'are present for' do
      specify 'header buttons' do
        expect(RailsController::HEADER_BUTTONS).to be_present
      end

      specify 'default sorting' do
        expect(RailsController::DEFAULT_SORT_SQL).to be_present
      end

      specify 'allowable deep sorts' do
        expect(RailsController::WHITELISTED_SORT_DEEP_JOINS).to be_present
      end
    end
  end

end
