require 'rails_helper'

describe Province, type: :model do
  subject(:province) { build_stubbed :province }

  it { is_expected.to be_valid }

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_uniqueness_of :name }
    it { is_expected.to validate_uniqueness_of :code }
    it { is_expected.to ensure_inclusion_of(:code).in_range 10..99 }
    it { is_expected.to have_many :partners }
  end
end
