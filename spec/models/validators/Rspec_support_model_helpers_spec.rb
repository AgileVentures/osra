require 'rails_helper'

describe "Rspec matchers" do
  let(:test_model) do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :date_attr, :other_attr

      validates :date_attr, valid_date_presence: true
    end
  end

  subject { test_model.new }

  describe "should have a functional 'have_validation' matcher" do
    it { is_expected.to have_validation ValidDatePresenceValidator, :on => :date_attr }
    it { is_expected.to_not have_validation ValidDatePresenceValidator, :on => :other_attr }
  end
end
