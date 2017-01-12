require 'rails_helper'

RSpec.describe Orphan, type: :model do

  let(:orphan) { create :orphan_full }
  let(:unsponsored_sponsorship_status) { Orphan.sponsorship_statuses[:unsponsored] }
  let(:sponsored_sponsorship_status) { Orphan.sponsorship_statuses[:sponsored] }
  let(:inactive_status) { Orphan.statuses[:inactive] }
  let(:active_status) { Orphan.statuses[:active] }

  describe 'filter scope' do
    describe "when finds nothing" do
      specify "returns AR relation" do
        filter_params = build :orphan_filter, orphan: orphan

        expect(Orphan.filter(filter_params).class).to eq Orphan::ActiveRecord_Relation
      end
    end
    describe "when finds something" do
      specify "with all valid params" do
        filter_params = build :orphan_filter, orphan: orphan
        filter_params[:status] = Orphan.statuses[filter_params[:status]]
        filter_params[:sponsorship_status] = Orphan.sponsorship_statuses[filter_params[:sponsorship_status]]

        expect(Orphan.with_filter_fields.filter filter_params).to eq [orphan]
      end

      specify "with NO params" do
        orphan = create :orphan

        expect(Orphan.filter({}).class).to eq Orphan::ActiveRecord_Relation
      end

      specify "with only NON empty params" do
        orphan = create :orphan
        filter_params = {
          name_option: "contains",
        }
        expect(Orphan.filter(filter_params).class).to eq Orphan::ActiveRecord_Relation
      end

      describe 'on each param' do
        before :each do
          create_list :orphan, 4, { gender: "Male", father_is_martyr: false,
                                    mother_alive: false, goes_to_school: false,
                                    priority: "High", status: inactive_status,
                                    sponsorship_status: unsponsored_sponsorship_status,
                                    province_code: 0
                                  }
          @filter_params = {}
        end

        describe "name" do
          specify "name_option: equals" do
            unique_orphan = create :orphan, name: "Unique001"
            @filter_params[:name_option] = "equals"
            @filter_params[:name_value] = unique_orphan.name

            expect(Orphan.filter @filter_params).to eq [unique_orphan]
          end

          specify "name_option: contains" do
            unique_orphan = create :orphan, name: "Unique001"
            @filter_params[:name_option] = "contains"
            @filter_params[:name_value] = unique_orphan.name[-6..-2]

            expect(Orphan.filter @filter_params).to eq [unique_orphan]
          end

          specify "name_option: starts_with" do
            unique_orphan = create :orphan, name: "001Unique"
            @filter_params[:name_option] = "starts_with"
            @filter_params[:name_value] = unique_orphan.name[0..5]

            expect(Orphan.filter @filter_params).to eq [unique_orphan]
          end

          specify "name_option: ends_with" do
            unique_orphan = create :orphan, name: "Unique001"
            @filter_params[:name_option] = "ends_with"
            @filter_params[:name_value] = unique_orphan.name[-5..-1]

            expect(Orphan.filter @filter_params).to eq [unique_orphan]
          end
        end

        describe "father_given_name" do
          specify "father_given_name_option: equals" do
            unique_orphan = create :orphan, father_given_name: "Unique001"
            @filter_params[:father_given_name_option] = "equals"
            @filter_params[:father_given_name_value] = unique_orphan.father_given_name

            expect(Orphan.filter @filter_params).to eq [unique_orphan]
          end

          specify "father_given_name_option: contains" do
            unique_orphan = create :orphan, father_given_name: "Unique001"
            @filter_params[:father_given_name_option] = "contains"
            @filter_params[:father_given_name_value] = unique_orphan.father_given_name[-6..-2]

            expect(Orphan.filter @filter_params).to eq [unique_orphan]
          end

          specify "father_given_name_option: starts_with" do
            unique_orphan = create :orphan, father_given_name: "001Unique"
            @filter_params[:father_given_name_option] = "starts_with"
            @filter_params[:father_given_name_value] = unique_orphan.father_given_name[0..5]

            expect(Orphan.filter @filter_params).to eq [unique_orphan]
          end

          specify "father_given_name_option: ends_with" do
            unique_orphan = create :orphan, father_given_name: "Unique001"
            @filter_params[:father_given_name_option] = "ends_with"
            @filter_params[:father_given_name_value] = unique_orphan.father_given_name[-5..-1]

            expect(Orphan.filter @filter_params).to eq [unique_orphan]
          end
        end

        describe "family_name" do
          specify "family_name_option: equals" do
            unique_orphan = create :orphan, family_name: "Unique001"
            @filter_params[:family_name_option] = "equals"
            @filter_params[:family_name_value] = unique_orphan.family_name

            expect(Orphan.filter @filter_params).to eq [unique_orphan]
          end

          specify "family_name_option: contains" do
            unique_orphan = create :orphan, family_name: "Unique001"
            @filter_params[:family_name_option] = "contains"
            @filter_params[:family_name_value] = unique_orphan.family_name[-6..-2]

            expect(Orphan.filter @filter_params).to eq [unique_orphan]
          end

          specify "family_name_option: starts_with" do
            unique_orphan = create :orphan, family_name: "001Unique"
            @filter_params[:family_name_option] = "starts_with"
            @filter_params[:family_name_value] = unique_orphan.family_name[0..5]

            expect(Orphan.filter @filter_params).to eq [unique_orphan]
          end

          specify "family_name_option: ends_with" do
            unique_orphan = create :orphan, family_name: "Unique001"
            @filter_params[:family_name_option] = "ends_with"
            @filter_params[:family_name_value] = unique_orphan.family_name[-5..-1]

            expect(Orphan.filter @filter_params).to eq [unique_orphan]
          end
        end

        specify "gender" do
          unique_orphan = create :orphan, gender: "Female"
          @filter_params[:gender] = unique_orphan.gender

          expect(Orphan.filter @filter_params).to eq [unique_orphan]
        end

        specify "date_of_birth" do
          unique_orphan = create :orphan, date_of_birth: (Date.current - 5.days)
          @filter_params[:date_of_birth_from] = unique_orphan.date_of_birth.to_date - 10.days
          @filter_params[:date_of_birth_until] = unique_orphan.date_of_birth.to_date + 1.days

          expect(Orphan.filter @filter_params).to eq [unique_orphan]
        end

        specify "province_code" do
          unique_orphan = create :orphan
          @filter_params[:province_code] = unique_orphan.province_code

          expect(Orphan.filter @filter_params).to eq [unique_orphan]
        end

        specify "original_address_city" do
          unique_orphan = create :orphan
          @filter_params[:original_address_city] = unique_orphan.original_address.city

          expect(Orphan.with_filter_fields.filter @filter_params).to eq [unique_orphan]
        end

        specify "priority" do
          unique_orphan = create :orphan, priority: "Normal"
          @filter_params[:priority] = unique_orphan.priority

          expect(Orphan.filter @filter_params).to eq [unique_orphan]
        end

        specify "sponsorship_status" do
          unique_orphan = create :orphan, sponsorship_status: sponsored_sponsorship_status
          @filter_params[:sponsorship_status] = Orphan.sponsorship_statuses[unique_orphan.sponsorship_status]

          expect(Orphan.filter @filter_params).to eq [unique_orphan]
        end

        specify "status" do
          unique_orphan = create :orphan, status: active_status
          @filter_params[:status] = Orphan.statuses[unique_orphan.status]

          expect(Orphan.filter @filter_params).to eq [unique_orphan]
        end

        specify "mother_alive" do
          unique_orphan = create :orphan, mother_alive: true
          @filter_params[:mother_alive] = unique_orphan.mother_alive

          expect(Orphan.filter @filter_params).to eq [unique_orphan]
        end

        specify "health_status" do
          unique_orphan = create :orphan, health_status: "UniqueHealthStatus1"
          @filter_params[:health_status] = unique_orphan.health_status

          expect(Orphan.filter @filter_params).to eq [unique_orphan]
        end

        specify "goes_to_school" do
          unique_orphan = create :orphan, goes_to_school: true
          @filter_params[:goes_to_school] = unique_orphan.goes_to_school

          expect(Orphan.filter @filter_params).to eq [unique_orphan]
        end

        specify "created_at" do
          unique_orphan = create :orphan, created_at: (Date.current + 5.days)
          @filter_params[:created_at_from] = unique_orphan.created_at.to_date - 1.day
          @filter_params[:created_at_until] = unique_orphan.created_at.to_date + 1.day

          expect(Orphan.filter @filter_params).to eq [unique_orphan]
        end

        specify "updated_at" do
          unique_orphan = create :orphan, updated_at: (Date.current + 5.days)
          @filter_params[:updated_at_from] = unique_orphan.updated_at.to_date - 1.day
          @filter_params[:updated_at_until] = unique_orphan.updated_at.to_date + 1.day

          expect(Orphan.filter @filter_params).to eq [unique_orphan]
        end
      end
    end
  end

  describe "should extend with WhereWithCondition module:" do
    specify "Orphan class methods" do
      expect(Orphan.methods.include? :where_with_conditions).to be true
    end

    specify "Orphan::ActiveRecord_Relation instance methods" do
      expect(Orphan::ActiveRecord_Relation.instance_methods.include? :where_with_conditions).to be true
    end
  end
end
