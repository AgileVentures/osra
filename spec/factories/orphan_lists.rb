FactoryGirl.define do
  factory :orphan_list do
    spreadsheet { Rack::Test::UploadedFile.new 'spec/fixtures/empty_xlsx.xlsx', 'application/vnd.ms-excel' }
    orphan_count { (0..50).to_a.sample }
    partner
  end
end

