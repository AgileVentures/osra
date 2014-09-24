require 'rails_helper'

describe OrphanList, type: :model do
  it { is_expected.to validate_presence_of :partner }
  it { is_expected.to validate_presence_of :orphan_count }
  it { is_expected.to validate_presence_of :spreadsheet }

  it { is_expected.to belong_to :partner }
end
