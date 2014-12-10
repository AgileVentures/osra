require 'rails_helper'
require 'rake'

describe 'rake db:clear_orphans' do

  before do
    load File.expand_path(Rails.root.join('lib/tasks/clear_orphans.rake'), __FILE__)
    Rake::Task.define_task(:environment)

    3.times { PendingOrphan.create }
    3.times { PendingOrphanList.create(:spreadsheet_file_name => 'file.xls') }
    one_sponsor = FactoryGirl.create :sponsor, :requested_orphan_count => 1
    two_sponsor = FactoryGirl.create :sponsor, :requested_orphan_count => 2
    2.times { FactoryGirl.create :sponsorship, sponsor: two_sponsor }
    FactoryGirl.create :sponsorship, sponsor: one_sponsor

    Rake::Task['db:clear_orphans'].invoke
  end

  it 'deletes all relevant records and resets request_fulfilled attributes' do
    expect(Orphan.count).to eq 0
    expect(OrphanList.count).to eq 0
    expect(Sponsorship.count).to eq 0
    expect(PendingOrphan.count).to eq 0
    expect(PendingOrphanList.count).to eq 0

    expect(Sponsor.all.map(&:request_fulfilled)).to eq [false, false]
  end
end
