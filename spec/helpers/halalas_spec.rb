# coding: utf-8
# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Halalas, type: :helper do

  specify 'requires integer-like input' do
    good_inputs= [123, -1234, 0, '123', '0', '-123']
    bad_inputs= [true, false, nil, 'foo', '6.0e7', '﷼']
    good_inputs.each do |input|
      expect{Halalas.new(input)}.to_not raise_error
    end
    bad_inputs.each do |input|
      expect{Halalas.new(input)}.to raise_error
    end
  end

  specify '#to_s' do
    expect(Halalas.new(123).to_s).to eq '1.23 SAR'
    expect(Halalas.new(0).to_s).to eq '0.00 SAR'
    expect(Halalas.new('-0').to_s).to eq '0.00 SAR'
    expect(Halalas.new(-1234).to_s).to eq '(12.34) SAR'
    expect(Halalas.new('1050').to_s).to eq '10.50 SAR'
    expect(Halalas.new(20000).to_s).to eq '200.00 SAR'
  end
end

