require 'rails_helper'

describe DateNotInFutureValidator do
  let(:options) { { } }
  let(:test_model) { date_attr_validator_class(options).new }

  it 'passes when the date attribute is in the past' do
    test_model.date_attr = 4.days.ago
    test_model.valid?
    expect(test_model.errors[:date_attr].size).to eq 0
  end

  it 'fails when the date attribute is in the future' do
    test_model.date_attr = 4.days.from_now
    test_model.valid?
    expect(test_model.errors[:date_attr].size).to eq 1
  end

  it 'returns the default message when custom is not specified' do
    test_model.date_attr = 4.days.from_now
    test_model.valid?

    expect(test_model.errors[:date_attr]).to eq ['is not valid (cannot be in the future)']
  end

  context 'with a custom error message' do
    let(:custom_message) { 'I am a custom message.' }
    before { options.merge!(message: custom_message) }

    it 'returns the custom message when provided' do
      test_model.date_attr = 4.days.from_now
      test_model.valid?

      expect(test_model.errors[:date_attr]).to eq [custom_message]
    end
  end
end
