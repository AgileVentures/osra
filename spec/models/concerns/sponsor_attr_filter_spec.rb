require 'rails_helper'

RSpec.describe Sponsor, type: :model do

  let(:sponsor) { create :sponsor }
  let(:individual_type) { SponsorType.find_by_name 'Individual' }
  let(:organization_type) { SponsorType.find_by_name 'Organization' }
  let(:on_hold_status) { Status.find_by_name 'On Hold' }
  let(:on_hold_sponsor) { create :sponsor, status: on_hold_status }

  describe 'filter scope' do
    describe "when finds nothing" do
      specify "returns AR relation" do
        filter_params = build :sponsor_filter, sponsor: sponsor

        expect(Sponsor.filter(filter_params).class).to eq Sponsor::ActiveRecord_Relation
      end
    end
    describe "when finds something" do
      specify "with all valid params" do
        filter_params = build :sponsor_filter, sponsor: sponsor

        expect(Sponsor.filter filter_params).to eq [sponsor]
      end

      specify "with NO params" do
        sponsor = create :sponsor

        expect(Sponsor.filter({}).class).to eq Sponsor::ActiveRecord_Relation
      end

      specify "with only NON empty params" do
        sponsor = create :sponsor
        filter_params = {
          name_option: "contains",
          active_sponsorship_count_option: "equals"
        }
        expect(Sponsor.filter(filter_params).class).to eq Sponsor::ActiveRecord_Relation
      end

      describe 'on each param' do
        before(:all) { travel_to Date.parse "15-12-2012" }
        after(:all) { travel_back }

        before :each do
          create_list :sponsor, 4, { gender: "Male", sponsor_type: individual_type,
                                     branch: Branch.first(2).sample }
          @filter_params = {}
        end

        describe "name" do
          specify "name_option: equals" do
            unique_sponsor = create :sponsor, name: "Unique001"
            @filter_params[:name_option] = "equals"
            @filter_params[:name_value] = unique_sponsor.name

            expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
          end

          specify "name_option: contains" do
            unique_sponsor = create :sponsor, name: "Unique001"
            @filter_params[:name_option] = "contains"
            @filter_params[:name_value] = unique_sponsor.name[-6..-2]

            expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
          end

          specify "name_option: starts_with" do
            unique_sponsor = create :sponsor, name: "001Unique"
            @filter_params[:name_option] = "starts_with"
            @filter_params[:name_value] = unique_sponsor.name[0..5]

            expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
          end

          specify "name_option: ends_with" do
            unique_sponsor = create :sponsor, name: "Unique001"
            @filter_params[:name_option] = "ends_with"
            @filter_params[:name_value] = unique_sponsor.name[-5..-1]

            expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
          end
        end

        specify "gender" do
          unique_sponsor = create :sponsor, gender: "Female"
          @filter_params[:gender] = unique_sponsor.gender

          expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
        end

        specify "branch_id" do
          unique_sponsor = create :sponsor, sponsor_type: individual_type, branch: Branch.third
          @filter_params[:branch_id] = unique_sponsor.branch_id

          expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
        end

        specify "organization_id" do
          unique_sponsor = create :sponsor, sponsor_type: organization_type, organization: Organization.first
          @filter_params[:organization_id] = unique_sponsor.organization_id

          expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
        end

        specify "status_id" do
          unique_sponsor = on_hold_sponsor
          @filter_params[:status_id] = unique_sponsor.status_id

          expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
        end

        specify "agent_id" do
          unique_sponsor = create :sponsor, agent: build_stubbed(:agent)
          @filter_params[:agent_id] = unique_sponsor.agent_id

          expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
        end

        specify "city" do
          unique_sponsor = create :sponsor, city: "UniqueCity001"
          @filter_params[:city] = unique_sponsor.city

          expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
        end

        specify "country" do
          unique_sponsor = create :sponsor
          @filter_params[:country] = unique_sponsor.country

          expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
        end

        specify "created_at" do
          unique_sponsor = create :sponsor, created_at: (Date.current + 5.days)
          @filter_params[:created_at_from] = unique_sponsor.created_at.to_date - 1.day
          @filter_params[:created_at_until] = unique_sponsor.created_at.to_date + 1.day

          expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
        end

        specify "updated_at" do
          unique_sponsor = create :sponsor, updated_at: (Date.current + 5.days)
          @filter_params[:updated_at_from] = unique_sponsor.updated_at.to_date - 1.day
          @filter_params[:updated_at_until] = unique_sponsor.updated_at.to_date + 1.day

          expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
        end

        specify "start_date" do
          unique_sponsor = create :sponsor, start_date: (Date.current + 5.days)
          @filter_params[:start_date_from] = unique_sponsor.start_date.to_date - 1.day
          @filter_params[:start_date_until] = unique_sponsor.start_date.to_date + 1.day

          expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
        end

        specify "request_fulfilled" do
          unique_sponsor = create :sponsor
          unique_sponsor.update_attributes!(request_fulfilled: true)
          @filter_params[:request_fulfilled] = unique_sponsor.request_fulfilled

          expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
        end

        describe "active_sponsorship_count" do
          specify "active_sponsorship_count_option: equals" do
            unique_sponsor = create :sponsor
            unique_sponsor.update_attributes!(active_sponsorship_count: 999)
            @filter_params[:active_sponsorship_count_option] = "equals"
            @filter_params[:active_sponsorship_count_value] = unique_sponsor.active_sponsorship_count

            expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
          end

          specify "active_sponsorship_count_option: greather_than" do
            unique_sponsor = create :sponsor
            unique_sponsor.update_attributes!(active_sponsorship_count: 999)
            @filter_params[:active_sponsorship_count_option] = "greather_than"
            @filter_params[:active_sponsorship_count_value] = unique_sponsor.active_sponsorship_count - 1

            expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
          end

          specify "active_sponsorship_count_option: less_than" do
            unique_sponsor = create :sponsor
            unique_sponsor.update_attributes!(active_sponsorship_count: -999)
            @filter_params[:active_sponsorship_count_option] = "less_than"
            @filter_params[:active_sponsorship_count_value] = unique_sponsor.active_sponsorship_count + 1

            expect(Sponsor.filter @filter_params).to eq [unique_sponsor]
          end
        end
      end
    end
  end

  describe "should extend with WhereWithCondition module:" do
    specify "Sponsor class methods" do
      expect(Sponsor.methods.include? :where_with_conditions).to be true
    end

    specify "Sponsor::ActiveRecord_Relation instance methods" do
      expect(Sponsor::ActiveRecord_Relation.instance_methods.include? :where_with_conditions).to be true
    end
  end
end
