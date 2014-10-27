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
    let(:active_status) { Status.find_by_name 'Active' }
    let(:on_hold_status) { Status.find_by_name 'On Hold' }

    it 'sets status to default if it is blank' do
      test_model.default_status_to_active
      expect(test_model.status).to eq active_status
    end

    it 'does not change status if it is already set' do
      test_model.status = on_hold_status
      test_model.default_status_to_active
      expect(test_model.status).to eq on_hold_status
    end
  end

  describe 'set_start_date' do
    it 'sets start_date to default if it is blank' do
      test_model.default_start_date_to_today
      expect(test_model.start_date).to eq Date.current
    end

    it 'does not change start_date if it is already set' do
      test_model.start_date = Date.yesterday
      test_model.default_start_date_to_today
      expect(test_model.start_date).to eq Date.yesterday
    end
  end
end
