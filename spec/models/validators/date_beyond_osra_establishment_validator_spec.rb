require 'rails_helper'

RSpec.describe DateBeyondOsraEstablishmentValidator do
  let(:test_model) do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :date_attr

      validates :date_attr, date_beyond_osra_establishment: true
    end
  end

  subject { test_model.new }

  it 'passes when attribute is a valid date, later than the OSRA establishment date' do
    subject.date_attr = Date.current
    expect(subject).to be_valid
  end

  it 'fails when attribute is a valid date, beyond OSRA establishment date' do
    subject.date_attr = Date.new(2010,01,01)
    expect(subject).to_not be_valid
  end

  it 'returns appropriate message when attribute is a valid date, beyond OSRA establishment date' do
    subject.date_attr = Date.new(2010,01,01)
    subject.valid?
    expect(subject.errors[:date_attr]).to eq ['is not valid (cannot be earlier than the OSRA establishment date of 2012-04-01)']
  end
end
