require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

RSpec.describe DateNotBeyondFirstOfNextMonthValidator do
  let(:test_model) do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :date_attr

      validates :date_attr, date_not_beyond_first_of_next_month: true
    end
  end

  subject { test_model.new }

  before(:all) { travel_to Date.parse "15-12-2012" }
  after(:all) { travel_back }

  let (:today) { Date.current }
  let (:yesterday) { today.yesterday }
  let (:first_of_next_month) { today.beginning_of_month.next_month }
  let (:last_day_of_the_month) { first_of_next_month - 1.day }
  let (:second_of_next_month) { first_of_next_month + 1.day }
  let (:two_months_ahead) { today + 2.months }

  describe "succeeds when date is not beyond first of next month" do
    it { is_expected.to allow_value(today).for :date_attr }
    it { is_expected.to allow_value(first_of_next_month).for :date_attr }
    it { is_expected.to allow_value(yesterday).for :date_attr }
    it { is_expected.to allow_value(last_day_of_the_month).for :date_attr }
  end

  describe "fails when date is beyond first of next month" do
    it { is_expected.to_not allow_value(second_of_next_month).for :date_attr }
    it { is_expected.to_not allow_value(two_months_ahead).for :date_attr }
  end

  it "allows date attribute to be an invalid date format" do
    expect_any_instance_of(DateNotBeyondFirstOfNextMonthValidator).to receive(:valid_date?).and_return false
    expect(subject).to allow_value("invalid_date_format").for :date_attr
  end
end
