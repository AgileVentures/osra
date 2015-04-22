require 'rails_helper'

describe Partner, type: :model do

  it 'should have a valid factory' do
    expect(build_stubbed :partner).to be_valid
  end

  it { is_expected.to validate_presence_of :name }

  describe 'name uniqueness validation' do
    before { create :partner }
    it { is_expected.to validate_uniqueness_of :name }
  end

  it { is_expected.to validate_presence_of :province }
  it { is_expected.to belong_to :province }
  it { is_expected.to belong_to :status }

  context 'start_date validation' do
    it { is_expected.to have_validation :valid_date_presence, :on => :start_date }
    it { is_expected.to have_validation :date_not_in_future, :on => :start_date }
    it { is_expected.to have_validation :date_beyond_osra_establishment, :on => :start_date }
  end

  it { is_expected.to have_many :orphan_lists }
  it { is_expected.to have_many(:orphans).through :orphan_lists }

  it 'should override the default pagination per_page' do
    expect(Partner.per_page).to eq 10
  end

  describe 'methods & scopes' do

    specify '.all_names should return a list sorted by name' do
      Partner.all.map(&:name).sort.each_with_index do |name, index|
        expect(name).to eq Partner.all_names[index]
      end
    end

  end

  describe 'callbacks' do
    describe 'after_initialize #set_defaults' do
      describe 'status' do
        let(:active_status) { Status.find_by_name 'Active' }
        let(:on_hold_status) { Status.find_by_name 'On Hold' }

        it 'defaults status to "Active"' do
          expect(Partner.new.status).to eq active_status
        end

        it 'sets non-default status if provided' do
          options = { status: on_hold_status }
          expect(Partner.new(options).status).to eq on_hold_status
        end
      end

      describe 'start_date' do
        it 'defaults start_date to current date' do
          expect(Partner.new.start_date).to eq Date.current
        end

        it 'sets non-default start_date if provided' do
          options = { start_date: Date.yesterday }
          expect(Partner.new(options).start_date).to eq Date.yesterday
        end
      end
    end

    describe 'before_create #generate_osra_num' do
      let(:new_partner) { build :partner }

      it 'sets osra_num' do
        new_partner.save!
        expect(new_partner.osra_num).not_to be_nil
      end

      it 'sets the first 2 digits of osra_num to province code' do
        new_partner.save!
        expect(new_partner.osra_num[0..1]).to eq new_partner.province.code.to_s
      end

      it 'sets the last 3 digits of osra_num to sequential_id' do
        new_partner.sequential_id = 999
        new_partner.save!
        expect(new_partner.osra_num[2..-1]).to eq '999'
      end
    end
  end

  describe 'create' do
    it 'should accept a province' do
      province = Province.all.sample
      partner = Partner.create!(name: "Some Name", region: "Some Region", contact_details: "Some Details", province: province)
      expect(partner.province.id).to eq(province.id)
    end
  end

  describe 'update' do
    it 'should not change province' do
      partner = FactoryGirl.create(:partner)
      remaining_provinces = Province.where.not(id: partner.province.id)
      new_province = remaining_provinces.sample
      partner.update!(name: "Updated Name", region: "Updated Region", contact_details: "Updated Details", province: new_province)
      partner.reload
      expect(partner.province.id).not_to eq(new_province.id)
    end
  end

end
