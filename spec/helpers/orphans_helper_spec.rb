require 'rails_helper'

RSpec.describe OrphansHelper, :type => :helper do
    let(:orphans_unsponsored) { FactoryGirl.create_list( :orphan, 3, status: 'active', sponsorship_status: 'unsponsored') }
    let(:orphans_sponsored) { FactoryGirl.create_list( :orphan, 3, status: 'active', sponsorship_status: 'sponsored') }
        
    describe "#orphans_count" do
        
        it "should count the number of unsponsored orphans" do
            expect(orphans_count(orphans_unsponsored, "eligible_for_sponsorship?")).to eq 3             
        end
        
        it "should return zero orphans for sponsored? method" do 
           expect(orphans_count(orphans_unsponsored, "sponsored?")).to eq 0 
        end
        
        it "should count the number of sponsored orphans" do
            expect(orphans_count(orphans_sponsored, "sponsored?")).to eq 3
        end
        
        it "should return zero orphans for eligible_for_sponsorship? method" do
           expect(orphans_count(orphans_sponsored, "eligible_for_sponsorship?")).to eq 0 
        end
    end
    
    describe "#orphans_filter" do
        
        it "should return an array" do
            expect(orphans_filter("eligible_for_sponsorship", orphans_unsponsored)).to be_a(Array) 
        end
        
        it "should return an array with a correct number of elements with eligible_for_sponsorship? method as input" do
            the_array = orphans_filter("eligible_for_sponsorship", orphans_unsponsored)
            expect(the_array.count).to eq 3
        end
        
        it "should return an array with a correct number of elements with sponsored? method as input" do
            the_array = orphans_filter("sponsored", orphans_sponsored)
            expect(the_array.count).to eq 3
        end
        
        it "should return an empty array" do
            the_array = orphans_filter("sponsored", orphans_unsponsored)
            expect(the_array.count).to eq 0
        end
    end
end