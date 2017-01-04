require 'rails_helper'

RSpec.describe Cashbox, type: :model do

  it { is_expected.to validate_numericality_of(:balance).only_integer }
  it { is_expected.to have_many :deposits }
  it { is_expected.to have_many :withdrawls }

end
