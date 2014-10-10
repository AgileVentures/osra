require 'rails_helper'
require 'orphan_importer'

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
    OrphanSponsorshipStatus.create(name: 'Unsponsored', code: 1)
  }

  let (:empty_importer) { OrphanImporter.new('spec/fixtures/empty_xlsx.xlsx') }
  let (:one_orphan_importer) { OrphanImporter.new('spec/fixtures/one_orphan_xlsx.xlsx') }
  let (:three_orphans_importer) { OrphanImporter.new('spec/fixtures/three_orphans_xlsx.xlsx') }
  let (:three_invalid_orphans_importer) { OrphanImporter.new('spec/fixtures/three_invalid_orphans_xlsx.xlsx') }

  let (:empty_results) { empty_importer.extract_orphans }
  let (:one_orphan_result) { one_orphan_importer.extract_orphans }
  let (:three_orphans_result) { three_orphans_importer.extract_orphans }
  let (:three_invalid_orphans_result) { three_invalid_orphans_importer.extract_orphans }

  describe '.doc' do

    it 'should reject opening a non Excel file with an error' do
      importer = OrphanImporter.new('spec/fixtures/not_an_excel_file.txt')
      expect(importer).not_to be_valid
      expect(importer.import_errors[0][:error]).to include('not a valid Excel file')
    end

    it 'should open an .xlsx file with no errors' do
      expect(empty_importer).to be_valid
    end

    it 'should open an .xls file with no errors' do
      importer = OrphanImporter.new('spec/fixtures/empty_xls.xls')
      expect(importer).to be_valid
    end

    it 'should reject opening a non Excel file even if it has an Excel extension' do
      importer = OrphanImporter.new('spec/fixtures/fake_excel_file.png.xls')
      expect(importer).not_to be_valid
      expect(importer.import_errors[0][:error]).to include 'not a valid Excel file'
    end

  end

  describe '.extract_orphans' do

    it 'should parse an empty file and return an appropriate error message' do
      expect(empty_results[0][:error]).to include 'Does not contain any orphan records'
    end

    it 'should parse one valid record and return one orphan hash and no errors' do
      expect(one_orphan_result.count).to eq 1
      expect(one_orphan_importer).to be_valid
    end

    it 'should parse three valid records and return three orphan hashes and no errors' do
      expect(three_orphans_result.count).to eq 3
      expect(three_orphans_importer).to be_valid
    end

    it 'should parse three invalid records and return errors' do
      expect(three_invalid_orphans_result.empty?).to eq false
      expect(three_invalid_orphans_importer).not_to be_valid
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

  after(:all) do
    Province.delete_all
    OrphanStatus.delete_all
    OrphanSponsorshipStatus.delete_all
  end

end