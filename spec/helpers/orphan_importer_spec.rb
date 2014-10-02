require 'rails_helper'

describe OrphanImporter do

  # I don't like this
  before(:all) {
    Province.create(name: 'Damascus & Rif Dimashq', code: 11)
    Province.create(name: 'Aleppo', code: 12)
    Province.create(name: 'Homs', code: 13)
    Province.create(name: 'Hama', code: 14)
    Province.create(name: 'Latakia', code: 15)
    Province.create(name: 'Deir Al-Zor', code: 16)
    Province.create(name: 'Daraa', code: 17)
    Province.create(name: 'Idlib', code: 18)
    Province.create(name: 'Ar Raqqah', code: 19)
    Province.create(name: 'Al Ḥasakah', code: 20)
    Province.create(name: 'Tartous', code: 21)
    Province.create(name: 'Al-Suwayada', code: 22)
    Province.create(name: 'Al-Quneitera', code: 23)
    Province.create(name: 'Outside Syria', code: 29)
    OrphanStatus.create(name: 'Active', code: 1)
    OrphanStatus.create(name: 'Inactive', code: 2)
    OrphanStatus.create(name: 'On Hold', code: 3)
    OrphanStatus.create(name: 'Under Revision', code: 4)
  }

  let(:one_orphan_import) { extract_orphans('spec/fixtures/one_orphan_xlsx.xlsx') }
  let(:three_orphans_import) { extract_orphans('spec/fixtures/three_orphans_xlsx.xlsx') }

  it 'should parse one valid record and return one orphan object and no errors' do
    expect(one_orphan_import[:errors].empty?).to eq true
    expect(one_orphan_import[:orphans].count).to eq 1
  end

  it 'should parse three valid records and return three orphan objects and no errors' do
    expect(three_orphans_import[:errors].empty?).to eq true
    expect(three_orphans_import[:orphans].count).to eq 3
  end

  it 'should return valid original and current address objects for orphans' do
    orphan = one_orphan_import[:orphans][0]
    expect(orphan.current_address).to be_valid
    expect(orphan.original_address).to be_valid
  end

  it 'should return valid orphan objects' do
    [one_orphan_import, three_orphans_import].each do |result|
      result[:orphans].each do |orphan|
        expect(orphan).to be_valid
      end
    end
  end

  after(:all) do
    Province.delete_all
    OrphanStatus.delete_all
  end

end