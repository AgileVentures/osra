require 'rails_helper'

RSpec.describe OrphansHelper, :type => :helper do
    
    describe "#orphans_count" do
        subject { create_list( :orphan, 3,  ) }
        it "should have count the number of orphans" do
            expect(subject.count).to eq 3               
        end
    end
end