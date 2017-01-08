# coding: utf-8
# frozen_string_literal: true
require 'rails_helper'

describe Payment, type: :model do
  subject { build :payment }

  it 'should have a valid factory' do
    expect(subject).to be_valid
  end

  it { is_expected.to validate_numericality_of(:amount).only_integer }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
end
