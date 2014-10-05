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

  let (:one_orphan_importer) { OrphanImporter.new('spec/fixtures/one_orphan_xlsx.xlsx') }
  let (:three_orphans_importer) { OrphanImporter.new('spec/fixtures/three_orphans_xlsx.xlsx') }
  let (:three_invalid_orphans_importer) { OrphanImporter.new('spec/fixtures/three_invalid_orphans_xlsx.xlsx') }

  let (:one_orphan_result) { one_orphan_importer.extract_orphans }
  let (:three_orphans_result) { three_orphans_importer.extract_orphans }
  let (:three_invalid_orphans_result) { three_invalid_orphans_importer.extract_orphans }

  describe '.extract_orphans' do

    it 'should parse one valid record and return one orphan hash and no errors' do
      expect(one_orphan_result.count).to eq 1
      expect(one_orphan_importer.valid?).to eq true
    end

    it 'should parse three valid records and return three orphan hashes and no errors' do
      expect(three_orphans_result.count).to eq 3
      expect(three_orphans_importer.valid?).to eq true
    end

    it 'should parse three invalid records and return errors' do
      expect(three_invalid_orphans_result.empty?).to eq false
      expect(three_invalid_orphans_importer.valid?).to eq false
    end

    it 'should return valid pending orphan objects' do
      [one_orphan_result, three_orphans_result].each do |result|
        result.each do |orphan|
          expect(orphan).to be_valid
        end
      end
    end

  end

  describe '#to_orphan' do

    it 'should return valid orphan objects' do
      [one_orphan_result, three_orphans_result].each do |result|
        result.each do |fields|
          expect(OrphanImporter.to_orphan fields).to be_valid
        end
      end
    end

  end

  after(:all) do
    Province.delete_all
    OrphanStatus.delete_all
  end
end


