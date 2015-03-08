require 'rails_helper'

RSpec.describe DateNotBeyondFirstOfNextMonthValidator do
  let(:test_model) do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :date_attr

      validates :date_attr, date_not_beyond_first_of_next_month: true
    end
  end

  subject { test_model.new }

  today = Date.current
  first_of_next_month = today.beginning_of_month.next_month
  yesterday = today.yesterday
  second_of_next_month = first_of_next_month + 1.day
  two_months_ahead = today + 2.months

  [today, first_of_next_month, yesterday].each do |good_date|
    it { is_expected.to allow_value(good_date).for :date_attr }
  end

  [second_of_next_month, two_months_ahead].each do |bad_date|
    it { is_expected.to_not allow_value(bad_date).for :date_attr }
  end

  it "allows date attribute to be an invalid date format" do
    expect_any_instance_of(DateNotBeyondFirstOfNextMonthValidator).to receive(:valid_date?).and_return false
    expect(subject).to allow_value("invalid_date_format").for :date_attr
  end
end
