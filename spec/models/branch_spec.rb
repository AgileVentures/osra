require 'rails_helper'

describe Branch, type: :model do

  it { is_expected.to validate_presence_of :name}

  it { is_expected.to validate_presence_of :code }

  it { is_expected.to validate_numericality_of(:code).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(99) }

  end
