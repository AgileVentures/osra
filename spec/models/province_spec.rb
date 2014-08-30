require 'rails_helper'

describe Province, type: :model do

  it "should not be valid without a name" do
    expect(Province.new(:code => 11)).to be_invalid
  end

  it "should reject a province with an invalid code" do
    expect(Province.new(:name => "Damascus", :code => 99)).to be_invalid
  end

  it "should accept provinces with names and valid codes" do
    #   DatabaseCleaner.clean
    Province.destroy_all
    [11, 12, 13, 14, 15, 16, 17, 18, 19, 29].each do |c|
      expect(Province.new(:name => "Damascus#{c}", :code => c)).to be_valid
    end
  end

  it "name should be unique" do
    Province.create(:name => "Damascus", :code => 11)
    expect(Province.new(:name => "Damascus", :code => 12)).to be_invalid
  end

  it "code should be unique" do
    Province.create(:name => "Damascus", :code => 11)
    expect(Province.new(:name => "Aleppo", :code => 11)).to be_invalid
  end

  after(:each) do
    Province.all.each do |p|
      p.destroy!
    end
  end

end
