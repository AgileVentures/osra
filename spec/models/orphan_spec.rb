require 'rails_helper'

describe Orphan, type: :model do

  let(:active_orphan_status) { OrphanStatus.find_by_name 'Active' }
  let(:inactive_orphan_status) { OrphanStatus.find_by_name 'Inactive' }
  let(:on_hold_orphan_status) { OrphanStatus.find_by_name 'On Hold' }
  let(:under_revision_orphan_status) { OrphanStatus.find_by_name 'Under Revision' }
  let(:sponsored_status) { OrphanSponsorshipStatus.find_by_name 'Sponsored' }
  let(:unsponsored_status) { OrphanSponsorshipStatus.find_by_name 'Unsponsored' }
  let(:previously_sponsored_status) { OrphanSponsorshipStatus.find_by_name 'Previously Sponsored' }
  let(:on_hold_sponsorship_status) { OrphanSponsorshipStatus.find_by_name 'On Hold' }

  subject { build :orphan }

  it 'should have a valid factory' do
    expect(subject).to be_valid
  end

  it 'should have default Orphan sort criteria' do
    expect(Orphan::NEW_SPONSORSHIP_SORT_SQL).to be_present
  end

  it { is_expected.to validate_presence_of :name }

  it 'validates orphan uniqueness' do
    orphan = create :orphan
    duplicate_orphan = orphan.dup
    expect(duplicate_orphan).not_to be_valid
    expect(duplicate_orphan.errors[:name]).
      to include 'taken: an orphan with this name, father, mother & family name is already in the database.'
  end


  it { is_expected.to validate_presence_of :father_given_name }
  it { is_expected.to validate_presence_of :family_name }
  it { is_expected.to_not allow_value(nil).for(:father_is_martyr) }

  it { is_expected.to validate_presence_of :mother_name }
  it { is_expected.to_not allow_value(nil).for(:mother_alive) }
  it { is_expected.to_not allow_value(nil).for(:father_deceased) }

  it { is_expected.to allow_value(Date.today - 5, Date.current).for(:date_of_birth) }
  it { is_expected.to_not allow_value(Date.today + 5).for(:date_of_birth) }
  [7, 'yes', true].each do |bad_date_value|
    it { is_expected.to_not allow_value(bad_date_value).for :date_of_birth }
  end

  it { is_expected.to validate_presence_of :gender }
  it { is_expected.to validate_inclusion_of(:gender).in_array Settings.lookup.gender }

  it { is_expected.to validate_presence_of :contact_number }

  it { is_expected.to_not allow_value(nil).for(:sponsored_by_another_org) }

  #it { is_expected.to validate_numericality_of(:minor_siblings_count).only_integer.is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:sponsored_minor_siblings_count).only_integer.is_greater_than_or_equal_to(0).allow_nil }

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

  describe "validates father's death details:" do
    let(:orphan) { build :orphan }

    context 'whether father is alive or deceased' do
      it 'validates presence of father_deceased & father_is_martyr' do
        expect(orphan).not_to allow_value(nil).for :father_deceased
        expect(orphan).not_to allow_value(nil).for :father_is_martyr
      end
    end

    context 'when father is alive' do
      before(:each) { orphan.father_deceased = false }

      it "validates absence of details of father's death" do
        expect(orphan).to validate_absence_of :father_date_of_death
        expect(orphan).to validate_absence_of :father_place_of_death
        expect(orphan).to validate_absence_of :father_cause_of_death
      end

      it 'only allows false for father_is_martyr' do
        expect(orphan).to allow_value(false).for :father_is_martyr
        expect(orphan).not_to allow_value(true).for :father_is_martyr
      end
    end

    context 'when father is dead' do
      before(:each) { orphan.father_deceased = true }

      it 'validates presence of father_date_of_death' do
        expect(orphan).to validate_presence_of :father_date_of_death
      end

      it 'does not allow future dates for father_date_of_death' do
        [Date.tomorrow, 1.year.from_now].each do |bad_date|
          expect(orphan).not_to allow_value(bad_date).for :father_date_of_death
        end
      end

      it 'allows father_is_martyr to be true or false' do
        expect(orphan).to allow_value(true).for :father_is_martyr
        expect(orphan).to allow_value(false).for :father_is_martyr
      end
    end
  end

  describe '#orphans_dob_within_1yr_of_fathers_death' do
    let(:orphan) { create :orphan,
                          :father_date_of_death => (1.year + 1.day).ago,
                          :father_deceased => true }

    it "is valid when orphan is born a year after father's death" do
      orphan.date_of_birth = 1.day.ago
      expect(orphan).to be_valid
    end

    it "is not valid when orphan is born more than a year after father's death" do
      orphan.date_of_birth = Date.current
      expect(orphan).not_to be_valid
    end
  end

  describe 'cross validation of sponsored siblings against siblings count' do
    let(:orphan) { create :orphan, :minor_siblings_count => 2 }

    it "is valid when sponsored siblings is less than siblings count" do
      orphan.sponsored_minor_siblings_count = 1
      expect(orphan).to be_valid
    end

    it "is not valid when sponsored siblings exceeds siblings count" do
      orphan.sponsored_minor_siblings_count = 3
      expect(orphan).not_to be_valid
    end

    it 'is valid when sponsored_minor_siblings_count is not specified (bug fix)' do
      orphan.sponsored_minor_siblings_count = nil
      expect(orphan).to be_valid
    end

    context 'when minor_sibling_count is nil' do
      it 'is valid when sponsored_minor_siblings_count is nil' do
        orphan.minor_siblings_count = nil
        orphan.sponsored_minor_siblings_count = nil
        expect(orphan).to be_valid
      end

      it 'is valid when sponsored_minor_siblings_count is 0' do
        orphan.minor_siblings_count = nil
        orphan.sponsored_minor_siblings_count = 0
        expect(orphan).to be_valid
      end

      it 'is not valid when sponsored_minor_siblings_count is greater than 0' do
        orphan.minor_siblings_count = nil
        orphan.sponsored_minor_siblings_count = 1
        expect(orphan).not_to be_valid
      end
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

      describe 'before_update #validate_inactivation' do
        let(:orphan) { create :orphan }

        context 'when orphan has no active sponsorships' do
          specify 's/he can be inactivated' do
            expect{ orphan.update!(orphan_status: inactive_orphan_status) }.not_to raise_exception
          end
        end

        context 'when orphan has active sponsorships' do
          before do
            sponsorship = build :sponsorship, orphan: orphan
            CreateSponsorship.new(sponsorship).call
          end

          specify 's/he cannot be inactivated' do
            expect{ orphan.update!(orphan_status: inactive_orphan_status) }.to raise_error ActiveRecord::RecordInvalid
            expect(orphan.errors[:orphan_status]).to include 'Cannot inactivate orphan with active sponsorships'
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
      let!(:active_previously_sponsored_high_priority_orphan) do
        create :orphan, priority: 'High',  orphan_status: active_orphan_status,
                orphan_sponsorship_status: previously_sponsored_status
      end
      let!(:active_unsponsored_high_priority_orphan) do
        create :orphan, priority: 'High',  orphan_status: active_orphan_status,
                orphan_sponsorship_status: unsponsored_status
      end

      describe 'methods' do

        describe 'name methods' do
          let(:orphan) do
            Orphan.new(name: 'Bart',
                       father_given_name: 'Homer',
                       family_name: 'Simpson')
          end

          specify '#father_name combines father_given_name & family_name' do
            expect(orphan.father_name).to eq 'Homer Simpson'
          end

          specify '#full_name combines name, father_given_name & family_name' do
            expect(orphan.full_name).to eq 'Bart Homer Simpson'
          end
        end

        specify '#eligible_for_sponsorship? should return true for eligible & false for ineligible orphans' do
          expect(active_unsponsored_orphan.eligible_for_sponsorship?).to eq true
          expect(active_previously_sponsored_orphan.eligible_for_sponsorship?).to eq true
          expect(active_previously_sponsored_high_priority_orphan.eligible_for_sponsorship?).to eq true
          expect(active_unsponsored_high_priority_orphan.eligible_for_sponsorship?).to eq true
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
              active_unsponsored_orphan.update!(name: 'New Name')
            end

            specify 'when one disqualifying orphan_status changes to another' do
              expect(ResolveOrphanSponsorshipStatus).not_to receive(:new)
              inactive_unsponsored_orphan.update!(orphan_status: on_hold_orphan_status)

              expect(ResolveOrphanSponsorshipStatus).not_to receive(:new)
              on_hold_sponsored_orphan.update!(orphan_status: under_revision_orphan_status)

              expect(ResolveOrphanSponsorshipStatus).not_to receive(:new)
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
              let(:sponsorships) { double(:empty? => false) }

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

        describe 'sponsorship methods' do
          context 'when orphan is unsponsored' do
            specify '#currently_sponsored? returns false' do
              expect(active_unsponsored_orphan.currently_sponsored?).to eq false
            end

            specify '#current_sponsorship returns nil' do
              expect(active_unsponsored_orphan.current_sponsorship).to be_nil
            end

            specify '#current_sponsor returns nil' do
              expect(active_unsponsored_orphan.current_sponsor).to be_nil
            end
          end

          context 'when orphan is sponsored' do
            let(:sponsor) { create :sponsor }
            let!(:sponsorship) { create :sponsorship,
                                        orphan:active_unsponsored_orphan,
                                        sponsor: sponsor }

            specify '#currently_sponsored? returns true' do
              expect(active_unsponsored_orphan.currently_sponsored?).to eq true
            end

            specify '#current_sponsorship returns currently active sponsorship' do
              expect(active_unsponsored_orphan.current_sponsorship).to eq sponsorship
            end

            specify '#current_sponsor returns current sponsor' do
              expect(active_unsponsored_orphan.current_sponsor).to eq sponsor
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
                                                     active_previously_sponsored_high_priority_orphan,
                                                     active_unsponsored_high_priority_orphan]
        end

        specify '.currently_unsponsored should correctly select unsponsored orphans only' do
          expect(Orphan.currently_unsponsored.to_a).to match_array [active_unsponsored_orphan,
                                                                    inactive_unsponsored_orphan,
                                                                    active_previously_sponsored_orphan,
                                                                    under_revision_unsponsored_orphan,
                                                                    active_previously_sponsored_high_priority_orphan,
                                                                    active_unsponsored_high_priority_orphan]
        end

        specify '.active.currently_unsponsored should correctly return active unsponsored orphans only' do
          expect(Orphan.active.currently_unsponsored.to_a).to match_array [active_unsponsored_orphan,
                                                                 active_previously_sponsored_orphan,
                                                                 active_previously_sponsored_high_priority_orphan,
                                                                 active_unsponsored_high_priority_orphan]
        end

        specify '.high_priority should correctly return high-priority orphans' do
          expect(Orphan.high_priority.to_a).to match_array [active_previously_sponsored_high_priority_orphan,
                                                            active_unsponsored_high_priority_orphan]
        end

        specify '.sort_by_eligibility should sort eligible orphans by sponsored_status, then priority' do
          Orphan.sort_by_eligibility.to_a.each_with_index.map do |orphan, index|
            expect([active_previously_sponsored_high_priority_orphan, active_previously_sponsored_orphan,
                    active_unsponsored_high_priority_orphan, active_unsponsored_orphan][index]).to eq orphan
          end
        end

      end
    end
  end
end
