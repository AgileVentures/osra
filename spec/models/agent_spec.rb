require 'rails_helper'

RSpec.describe Agent, :type => :model do

  it 'should have a valid factory' do
    expect(build_stubbed :agent).to be_valid
  end

  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of :first_name }
  it { is_expected.to validate_uniqueness_of :last_name }
  it { is_expected.to validate_uniqueness_of :email }

  [nil, '', 'not_an_email@'].each do |bad_email|
    it { is_expected.not_to allow_value(bad_email).for :email }
  end

  it { is_expected.to have_many :sponsors }

  describe 'methods' do
    describe '#full_name' do
      let(:agent) { Agent.new(first_name: 'Bob', last_name: 'Loblaw') }

      it 'should join first and last names with a space' do
        expect(agent.full_name).to eq 'Bob Loblaw'
      end
    end
  end
end
