require 'rails_helper'

describe Branch, type: :model do

  it { is_expected.to validate_presence_of :name}

  it { is_expected.to validate_presence_of :code }

  it { is_expected.to validate_numericality_of(:code).only_integer }

  it { is_expected.to ensure_inclusion_of(:code).in_range 0..99 }

  end
