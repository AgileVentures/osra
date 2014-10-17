require 'rails_helper'
require 'orphan_importer'

describe OrphanImporter do

  before(:each) {
    14.times { create :province }
    create :orphan_status, name: 'Active'
    create :orphan_sponsorship_status, name: 'Unsponsored'
  }

  let (:empty_importer) { OrphanImporter.new('spec/fixtures/empty_xlsx.xlsx') }
  let (:one_orphan_importer) { OrphanImporter.new('spec/fixtures/one_orphan_xlsx.xlsx') }
  let (:three_orphans_importer) { OrphanImporter.new('spec/fixtures/three_orphans_xlsx.xlsx') }
  let (:three_invalid_orphans_importer) { OrphanImporter.new('spec/fixtures/three_invalid_orphans_xlsx.xlsx') }

  let (:empty_results) { empty_importer.extract_orphans }
  let (:one_orphan_result) { one_orphan_importer.extract_orphans }
  let (:three_orphans_result) { three_orphans_importer.extract_orphans }
  let (:three_invalid_orphans_result) { three_invalid_orphans_importer.extract_orphans }

  describe '.open_doc' do

    it 'should reject opening a non Excel file with an error' do
      importer = OrphanImporter.new('spec/fixtures/not_an_excel_file.txt')
      importer.open_doc
      expect(importer).not_to be_valid
      expect(importer.import_errors[0][:error]).to include('not a valid Excel file')
    end

    it 'should open an .xls file with no errors' do
      importer = OrphanImporter.new('spec/fixtures/empty_xls.xls')
      expect(importer).to be_valid
    end

    it 'should reject opening an empty Excel file' do
      expect(empty_results[0][:error]).to include 'Does not contain any orphan records'
      expect(empty_importer).not_to be_valid
    end

    it 'should reject opening a non Excel file even if it has an Excel extension' do
      importer = OrphanImporter.new('spec/fixtures/fake_excel_file.png.xls')
      importer.open_doc
      expect(importer).not_to be_valid
      expect(importer.import_errors[0][:error]).to include 'not a valid Excel file'
    end

  end

  describe '.extract_orphans' do

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

  describe '#option_defined?' do

    context "the option exists in the settings file" do
      before :each do
        expect(Settings.import).to receive_message_chain(:options, '[]').and_return(true)
      end

      it 'should return true if an option exists' do
        expect(one_orphan_importer.send(:option_defined?, :valid_option)).to be true
      end

      it 'should not register an error if an option exists' do
        one_orphan_importer.send(:option_defined?, :valid_option)
        expect(one_orphan_importer).to be_valid
      end

    end

    context "the option does not exist in the settings file" do
      before :each do
        expect(Settings.import).to receive_message_chain(:options, '[]').and_return(nil)
      end
      it 'should return false in an option does not exist' do
        expect(one_orphan_importer.send(:option_defined?, :valid_option)).to be false
      end

      it 'should register an error if an option does not exist' do
        one_orphan_importer.send(:option_defined?, :valid_option)
        expect(one_orphan_importer).not_to be_valid
      end
    end
  end

end
