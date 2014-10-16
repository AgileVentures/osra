require 'rails_helper'

describe Orphan, type: :model do

  let!(:active_orphan_status) { create :orphan_status, name: 'Active' }
  let!(:inactive_orphan_status) { create :orphan_status, name: 'Inactive' }
  let!(:under_revision_orphan_status) { create :orphan_status, name: 'Under Revision' }
  let!(:on_hold_orphan_status) { create :orphan_status, name: 'On Hold' }
  let!(:sponsored_status) { create :orphan_sponsorship_status, name: 'Sponsored' }
  let!(:unsponsored_status) { create :orphan_sponsorship_status, name: 'Unsponsored' }
  let!(:previously_sponsored_status) { create :orphan_sponsorship_status, name: 'Previously Sponsored' }
  let!(:on_hold_sponsorship_status) { create :orphan_sponsorship_status, name: 'On Hold' }
  let!(:active_status) { create :status, name: 'Active' }

  subject { build :orphan }

  it 'should have a valid factory' do
    expect(subject).to be_valid
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :father_name }
  it { is_expected.to_not allow_value(nil).for(:father_is_martyr) }

  it { is_expected.to validate_presence_of :father_date_of_death }
  it { is_expected.to allow_value(Date.today - 5, Date.current).for(:father_date_of_death) }
  it { is_expected.to_not allow_value(Date.today + 5).for(:father_date_of_death) }
  [7, 'yes', true].each do |bad_date_value|
    it { is_expected.to_not allow_value(bad_date_value).for :father_date_of_death }
  end

  it { is_expected.to validate_presence_of :mother_name }
  it { is_expected.to_not allow_value(nil).for(:mother_alive) }

  it { is_expected.to allow_value(Date.today - 5, Date.current).for(:date_of_birth) }
  it { is_expected.to_not allow_value(Date.today + 5).for(:date_of_birth) }
  [7, 'yes', true].each do |bad_date_value|
    it { is_expected.to_not allow_value(bad_date_value).for :date_of_birth }
  end

  it { is_expected.to validate_presence_of :gender }
  it { is_expected.to validate_inclusion_of(:gender).in_array %w(Male Female) }

  it { is_expected.to validate_presence_of :contact_number }

  it { is_expected.to_not allow_value(nil).for(:sponsored_by_another_org) }

  it { is_expected.to validate_numericality_of(:minor_siblings_count).only_integer.is_greater_than_or_equal_to(0) }

  it { is_expected.to validate_presence_of :original_address }
  it { is_expected.to validate_presence_of :current_address }
  it { is_expected.to have_one(:original_address).class_name 'Address' }
  it { is_expected.to have_one(:current_address).class_name 'Address' }
  it { is_expected.to accept_nested_attributes_for :original_address }
  it { is_expected.to accept_nested_attributes_for :current_address }

  it { is_expected.to belong_to :orphan_status }
  it { is_expected.to belong_to :orphan_sponsorship_status }
  it { is_expected.to belong_to :orphan_list }
  it { is_expected.to validate_presence_of :orphan_status }
  it { is_expected.to validate_presence_of :priority }
  it { is_expected.to validate_inclusion_of(:priority).in_array %w(Normal High) }
  it { is_expected.to validate_presence_of :orphan_sponsorship_status }

  it 'validates presence of :orphan_list' do
    # need to stub out orphan.orphan_list.partner.province association
    # which gets called before_validation
    expect(subject).to receive(:partner_province_code).at_least(:once)
    expect(subject).to validate_presence_of :orphan_list
  end

  it { is_expected.to have_many :sponsorships }
  it { is_expected.to have_many(:sponsors).through :sponsorships }

  it { is_expected.to have_one(:partner).through(:orphan_list).autosave(false) }

  describe '#orphans_dob_within_1yr_of_fathers_death' do
    let(:orphan) { create :orphan, :father_date_of_death => (1.year + 1.day).ago }

    it "is valid when orphan is born a year after fathers death" do
      orphan.date_of_birth = 1.day.ago
      expect(orphan).to be_valid
    end

    it "is not valid when orphan is born more than a year after fathers death" do
      orphan.date_of_birth = Date.current
      expect(orphan).not_to be_valid
    end
  end

  describe '#less_than_22_yo_when_joined_osra' do
    let(:orphan) { build :orphan }
    context "orphan date of birth for new orphan record" do
      it "is valid when an orphan's birthday is less than 22 years ago" do
        orphan.date_of_birth = Date.current - 22.years + 1.day
        expect(orphan).to be_valid
      end

      it "is not valid when an orphan's birthday is 22 years ago" do
        orphan.date_of_birth = Date.current - 22.years
        expect(orphan).not_to be_valid
      end
    end

    context "orphan date of birth for existing orphan record" do
      before :each do
        orphan.created_at = Date.current - 5.days
        orphan.save!
      end

      it "is valid when birthday is less than 22 years before created date" do
        orphan.date_of_birth = orphan.created_at.to_date - 22.years + 1.day
        expect(orphan).to be_valid
      end

      it "is not valid when birthday is 22 years ago before created date" do
        orphan.date_of_birth = orphan.created_at.to_date - 22.years
        expect(orphan).not_to be_valid
      end
    end
  end

  describe 'initializers, methods & scopes' do
    describe 'initializers' do

      it 'defaults orphan_status to Active' do
        expect(Orphan.new.orphan_status).to eq active_orphan_status
      end

      it 'defaults orphan_sponsorship_status to Unsponsored' do
        expect(Orphan.new.orphan_sponsorship_status).to eq unsponsored_status
      end

      it 'defaults priority to Normal' do
        expect(Orphan.new.priority).to eq 'Normal'
      end

      describe 'before_create #generate_osra_num' do
        let(:orphan) { build :orphan }

        it 'sets province_code' do
          orphan.valid?
          expect(orphan.province_code).to eq orphan.partner_province_code
        end

        it 'generates osra_num on create' do
          orphan.save!
          expect(orphan.osra_num).not_to be_nil
        end

        it 'sets the first 2 digits of osra_num to the province code of partner' do
          expect(orphan).to receive(:partner_province_code).and_return(77)
          orphan.save!
          expect(orphan.osra_num[0..1]).to eq '77'
        end

        it 'sets the last 5 digits of osra_num to sequential_id padded by zeroes' do
          orphan.sequential_id = 333
          orphan.save!
          expect(orphan.osra_num[2..-1]).to eq '00333'
        end

        describe 'scoping of sequential_id on province code' do
          let(:orphan1_partner1) { build :orphan }
          let(:orphan1_partner2) { build :orphan }
          let(:orphan2_partner1) { build :orphan }

          it 'assigns correct sequential id numbers to orphans from different provinces' do
            expect(orphan1_partner1).to receive(:partner_province_code).and_return 13
            expect(orphan2_partner1).to receive(:partner_province_code).and_return 13
            expect(orphan1_partner2).to receive(:partner_province_code).and_return 22
            orphan1_partner1.save!
            orphan2_partner1.save!
            orphan1_partner2.save!
            expect(orphan1_partner1.sequential_id).to eq 1
            expect(orphan2_partner1.sequential_id).to eq 2
            expect(orphan1_partner2.sequential_id).to eq 1
          end
        end
      end
    end

    describe 'methods & scopes' do
      let!(:active_unsponsored_orphan) do
        create :orphan, orphan_status: active_orphan_status,
               orphan_sponsorship_status: unsponsored_status
      end
      let!(:active_previously_sponsored_orphan) do
        create :orphan, orphan_status: active_orphan_status,
               orphan_sponsorship_status: previously_sponsored_status
      end
      let!(:active_on_hold_orphan) do
        create :orphan, orphan_status: active_orphan_status,
               orphan_sponsorship_status: on_hold_sponsorship_status
      end
      let!(:on_hold_sponsored_orphan) do
        create :orphan, orphan_status: on_hold_orphan_status,
               orphan_sponsorship_status: sponsored_status
      end
      let!(:under_revision_unsponsored_orphan) do
        create :orphan, orphan_status: under_revision_orphan_status,
               orphan_sponsorship_status: unsponsored_status
      end
      let!(:inactive_unsponsored_orphan) do
        create :orphan, orphan_status: inactive_orphan_status,
               orphan_sponsorship_status: unsponsored_status
      end
      let!(:active_sponsored_orphan) do
        create :orphan, orphan_status: active_orphan_status,
               orphan_sponsorship_status: sponsored_status
      end
      let!(:high_priority_orphan) { create :orphan, priority: 'High' }

      describe 'methods' do

        specify '#full_name combines name + father_name' do
          orphan = active_unsponsored_orphan
          full_name = "#{orphan.name} #{orphan.father_name}"
          expect(orphan.full_name).to eq full_name
        end

        describe '#update_sponsorship_status!' do
          it 'correctly updates to Sponsored, Previously Sponsored & On Hold' do
            ['Sponsored', 'Previously Sponsored', 'On Hold'].each do |status_name|
              sponsorship_status = OrphanSponsorshipStatus.find_by_name(status_name)
              active_unsponsored_orphan.update_sponsorship_status!(status_name)
              expect(active_unsponsored_orphan.reload.orphan_sponsorship_status).to eq sponsorship_status
            end
          end

          it 'correctly updates to Unsponsored' do
            sponsorship_status = OrphanSponsorshipStatus.find_by_name('Unsponsored')
            active_sponsored_orphan.update_sponsorship_status!('Unsponsored')
            expect(active_sponsored_orphan.reload.orphan_sponsorship_status).to eq sponsorship_status
          end
        end

        specify '#eligible_for_sponsorship? should return true for eligible & false for ineligible orphans' do
          expect(active_unsponsored_orphan.eligible_for_sponsorship?).to eq true
          expect(active_previously_sponsored_orphan.eligible_for_sponsorship?).to eq true
          expect(high_priority_orphan.eligible_for_sponsorship?).to eq true
          expect(active_on_hold_orphan.eligible_for_sponsorship?).to eq false
          expect(on_hold_sponsored_orphan.eligible_for_sponsorship?).to eq false
          expect(under_revision_unsponsored_orphan.eligible_for_sponsorship?).to eq false
          expect(active_sponsored_orphan.eligible_for_sponsorship?).to eq false
          expect(inactive_unsponsored_orphan.eligible_for_sponsorship?).to eq false
        end

        describe '#qualify_for_sponsorship_by_status' do
          describe 'does not erroneously change orphan_sponsorship_status' do

            specify 'when orphan_status is not changed' do
              expect(active_unsponsored_orphan).not_to receive(:qualify_for_sponsorship_by_status)
              expect(active_unsponsored_orphan).not_to receive(:deactivate)
              expect(active_unsponsored_orphan).not_to receive(:reactivate)
              active_unsponsored_orphan.update!(name: 'New Name')
            end

            specify 'when one disqualifying orphan_status changes to another' do
              expect(inactive_unsponsored_orphan).not_to receive(:reactivate)
              inactive_unsponsored_orphan.update!(orphan_status: on_hold_orphan_status)

              expect(on_hold_sponsored_orphan).not_to receive(:reactivate)
              on_hold_sponsored_orphan.update!(orphan_status: under_revision_orphan_status)

              expect(under_revision_unsponsored_orphan).not_to receive(:reactivate)
              under_revision_unsponsored_orphan.update!(orphan_status: inactive_orphan_status)
            end
          end

          describe 'correctly disqualifies an orphan from new sponsorships' do
            it 'sets sponsorship_status On Hold when status changes from Active' do
              [inactive_orphan_status, on_hold_orphan_status, under_revision_orphan_status].each do |orphan_status|
                active_unsponsored_orphan.update!(orphan_status: orphan_status)
                expect(active_unsponsored_orphan.reload.orphan_sponsorship_status).to eq on_hold_sponsorship_status
              end
            end
          end

          describe 'correctly re-qualifies an orphan for sponsorship' do
            it 'sets sponsorship_status to Unsponsored when status -> Active for previously unsponsored orphan' do
              [inactive_unsponsored_orphan, under_revision_unsponsored_orphan].each do |orphan|
                expect(orphan).to receive(:sponsorships).and_return []

                orphan.update!(orphan_status: active_orphan_status)
                expect(orphan.reload.orphan_sponsorship_status).to eq unsponsored_status
              end
            end

            describe 'for orphans with sponsorships' do
              let(:orphan) { on_hold_sponsored_orphan }
              let(:sponsorships) { ['not empty'] }

              it 'sets sponsorship_status to Previously Sponsored when status -> Active for previously sponsored orphan' do
                expect(orphan).to receive(:sponsorships).at_least(:once).and_return sponsorships
                expect(sponsorships).to receive(:all_active).and_return []

                orphan.update!(orphan_status: active_orphan_status)
                expect(orphan.reload.orphan_sponsorship_status).to eq previously_sponsored_status
              end

              it 'sets sponsorship_status to Sponsored when status -> Active for currently sponsored orphan' do
                expect(orphan).to receive(:sponsorships).at_least(:once).and_return sponsorships
                expect(sponsorships).to receive(:all_active).at_least(:once).and_return ['not empty']

                orphan.update!(orphan_status: active_orphan_status)
                expect(orphan.reload.orphan_sponsorship_status).to eq sponsored_status
              end
            end
          end
        end
      end

      describe 'scopes' do

        specify '.active should correctly select active orphans only' do
          expect(Orphan.active.to_a).to match_array [active_sponsored_orphan,
                                                     active_unsponsored_orphan,
                                                     active_previously_sponsored_orphan,
                                                     active_on_hold_orphan,
                                                     high_priority_orphan]
        end

        specify '.currently_unsponsored should correctly select unsponsored orphans only' do
          expect(Orphan.currently_unsponsored.to_a).to match_array [active_unsponsored_orphan,
                                                                    inactive_unsponsored_orphan,
                                                                    active_previously_sponsored_orphan,
                                                                    under_revision_unsponsored_orphan,
                                                                    high_priority_orphan]
        end

        specify '.active.currently_unsponsored should correctly return active unsponsored orphans only' do
          expect(Orphan.active.currently_unsponsored.to_a).to match_array [active_unsponsored_orphan,
                                                                 active_previously_sponsored_orphan,
                                                                 high_priority_orphan]
        end

        specify '.high_priority should correctly return high-priority orphans' do
          expect(Orphan.high_priority.to_a).to eq [high_priority_orphan]
        end
      end
    end
  end
end
