require 'rails_helper'

RSpec.describe ColumnSort do

  let(:sponsor) { create :sponsor }
  let(:sponsor_list) { build_stubbed_list(:sponsor, 3) }

  specify '.column_sort' do
    expect(Sponsor.methods.include? :column_sort).to be true
  end

  context'with good params' do
    specify 'asc' do
      expect(Sponsor).to receive(:order).at_least(:once).with("name" => :asc).and_return(sponsor_list).at_least(:once)

      expect(Sponsor.column_sort("name", "asc")).to be sponsor_list
      expect(Sponsor.column_sort("name")).to be sponsor_list
    end

    specify 'desc' do
      expect(Sponsor).to receive(:order).with("name" => "desc").and_return(sponsor_list)
      expect(Sponsor.column_sort("name", "desc")).to be sponsor_list
    end
  end

  specify 'with bad params should return ActiveRelation object' do
    expect(Sponsor.column_sort("missing_collumn").class).to be Sponsor::ActiveRecord_Relation
    expect(Sponsor.column_sort(nil, nil).class).to be Sponsor::ActiveRecord_Relation
  end

end