require 'rails_helper'

describe SponsorType, type: :model do
  let(:sponsor_type) { build_stubbed(:sponsor_type) }

  subject { sponsor_type }

  it { should be_valid }

  describe 'validations' do
    context 'when name is missing' do
      before { sponsor_type.name = '' }
      it { should_not be_valid }
    end

    context 'when code is missing' do
      before { sponsor_type.code = '' }
      it { should_not be_valid }
    end

    context 'when name is not unique' do
      before { create(:sponsor_type, name: sponsor_type.name) }
      it { should_not be_valid }
      end

    context 'when code is not unique' do
      before { create(:sponsor_type, code: sponsor_type.code) }
      it { should_not be_valid }
    end
  end
end
