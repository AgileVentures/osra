require 'rails_helper'

RSpec.describe SponsorshipTotalsHelper, :type => :helper do

  specify 'total_active_sponsorships returns total of active sponsorships' do
    allow(Sponsorship).to receive(:all_active).and_return('a' * 5)

    expect(total_active_sponsorships).to eq 5
  end

  specify 'total_requested_sponsorships returns total of requested sponsorships' do
    sponsors = double
    allow(Sponsor).to receive(:all_active).and_return sponsors
    allow(sponsors).to receive(:pluck).with(:requested_orphan_count).
      and_return([1, 3, 5])

    expect(total_requested_sponsorships).to eq 9
  end
end
