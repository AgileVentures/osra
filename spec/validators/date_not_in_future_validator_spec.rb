require 'rails_helper'

describe DateNotInFutureValidator do
  let(:test_model) do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :date_attr

      validates :date_attr, date_not_in_future: true
    end
  end

  subject { test_model.new }

  it 'passes when attribute is a valid date' do
    subject.date_attr = Date.today
    expect(subject).to be_valid
  end

  it 'fails when attribute is not a date' do
    subject.date_attr = 'fake_date'
    expect(subject).to_not be_valid
  end

  it 'returns appropriate message when attribute is not a date' do
    subject.date_attr = 'fake_date'
    expect(subject).to_not be_valid
    expect(subject.errors[:date_attr]).to eq ['is not a valid date']
  end

  it 'passes when the date attribute is in the past' do
    subject.date_attr = 4.days.ago
    expect(subject).to be_valid
  end

  it 'fails when the date attribute is in the future' do
    subject.date_attr = 4.days.from_now
    expect(subject).not_to be_valid
  end

  it 'returns the default message when custom is not specified' do
    subject.date_attr = 4.days.from_now
    subject.valid?
    expect(subject.errors[:date_attr]).to eq ['is not valid (cannot be in the future)']
  end
end

