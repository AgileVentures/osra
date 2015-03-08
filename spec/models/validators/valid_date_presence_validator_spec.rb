require 'rails_helper'

describe ValidDatePresenceValidator do
  let(:test_model) do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :date_attr

      validates :date_attr, valid_date_presence: true
    end
  end

  subject { test_model.new }

  [Date.current, "10-10-2012"].each do |good_date_value|
    it 'passes when the date is valid' do
      subject.date_attr = good_date_value
      expect(subject).to be_valid
    end
  end

  [7, 'yes', true].each do |bad_date_value|
    it 'fails when the date attribute is not a date format' do
      subject.date_attr = bad_date_value
      expect(subject).not_to be_valid
    end
  end

  it 'returns appropriate message when the date attribute is not a date format' do
    subject.date_attr = "bad date format"
    subject.valid?
    expect(subject.errors[:date_attr]).to eq ['is not a valid date']
  end

end
