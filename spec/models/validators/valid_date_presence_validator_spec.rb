require 'rails_helper'

RSpec.describe ValidDatePresenceValidator do
  let(:test_model) do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :date_attr, :other_attr

      validates :date_attr, valid_date_presence: true
    end
  end

  subject { test_model.new }

  it 'passes when the date is valid' do
    expect_any_instance_of(ValidDatePresenceValidator).to receive(:valid_date?).and_return true
    expect(subject).to be_valid
  end

  it 'fails when the date attribute is not a valid date format' do
    expect_any_instance_of(ValidDatePresenceValidator).to receive(:valid_date?).and_return false
    expect(subject).not_to be_valid
  end

  it 'returns appropriate message when the date attribute is not a valid date format' do
    expect_any_instance_of(ValidDatePresenceValidator).to receive(:valid_date?).and_return false
    subject.valid?
    expect(subject.errors[:date_attr]).to eq ['is not a valid date']
  end

end
