require 'rails_helper'

RSpec.describe DateHelpers do
  let(:test_class) do
    Class.new { include DateHelpers }
  end

  subject { test_class.new }

  context 'valid_date?' do
    it 'method should be defined' do
      expect(subject.private_methods.include? :valid_date?).to eq true
    end

    it 'should return true for a valid date' do
      [Date.current, "10-10-2012"].each do |good_date_value|
        expect(subject.send(:valid_date?, good_date_value)).to eq true
      end
    end

    it 'should return false for an invalid date' do
      [7, 'yes', true].each do |bad_date_value|
        expect(subject.send(:valid_date?, bad_date_value)).to eq false
      end
    end
  end
end


