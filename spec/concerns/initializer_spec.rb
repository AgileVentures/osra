require 'rails_helper'

describe Initializer do

  let(:test_class) do
    Class.new do
      include Initializer
      attr_accessor :status, :start_date
    end
  end

  subject(:test_model) { test_class.new }

  describe 'set_status' do
    let!(:under_revision_status) { create :status, name: 'Under Revision' }
    let(:active_status) { build_stubbed :status }

    it 'sets status to default if it is blank' do
      test_model.set_status
      expect(test_model.status).to eq under_revision_status
    end

    it 'does not change status if it is already set' do
      test_model.status = active_status
      test_model.set_status
      expect(test_model.status).to eq active_status
    end
  end

  describe 'set_start_date' do
    it 'sets start_date to default if it is blank' do
      test_model.set_start_date
      expect(test_model.start_date).to eq Date.current
    end

    it 'does not change start_date if it is already set' do
      test_model.start_date = Date.yesterday
      test_model.set_start_date
      expect(test_model.start_date).to eq Date.yesterday
    end
  end
end
