#testing   /spec/support/model_helpers.rb
require 'rails_helper'

RSpec.describe "Rspec matchers" do
  let(:test_model) do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :date_attr, :other_attr

      validates :date_attr, valid_date_presence: true, allow_nil: true, allow_blank: true
    end
  end

  subject { test_model.new }

  describe "should have a functional 'have_validation' matcher" do
    describe "without options" do
      it { is_expected.to have_validation :valid_date_presence, :on => :date_attr }
      it { is_expected.to_not have_validation :valid_date_presence, :on => :other_attr }
    end

    describe "with options" do
      it { is_expected.to have_validation :valid_date_presence, :on => :date_attr,
                                          :options => [:allow_nil, :allow_blank] }
    end
  end
end
