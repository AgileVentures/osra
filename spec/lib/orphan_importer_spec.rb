require 'rails_helper'
require 'orphan_importer'

describe OrphanImporter do

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
          orphan = OrphanImporter.to_orphan fields
          orphan.orphan_list = build_stubbed :orphan_list
          expect(orphan).to be_valid
        end
      end
    end

  end

end