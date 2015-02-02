require 'rails_helper'
require 'orphan_importer'

describe OrphanImporter do
  before :each do
    @partner = create(:partner)
  end

  let (:empty_importer) { OrphanImporter.new('spec/fixtures/empty_xlsx.xlsx', @partner) }
  let (:one_orphan_importer) { OrphanImporter.new('spec/fixtures/one_orphan_xlsx.xlsx', @partner) }
  let (:three_orphans_importer) { OrphanImporter.new('spec/fixtures/three_orphans_xlsx.xlsx', @partner) }
  let (:three_invalid_orphans_importer) { OrphanImporter.new('spec/fixtures/three_invalid_orphans_xlsx.xlsx', @partner) }
  let (:four_orphans_with_duplicates_importer) { OrphanImporter.new('spec/fixtures/four_orphans_with_internal_duplicate_xlsx.xlsx', @partner) }

  let (:empty_results) { empty_importer.extract_orphans }

  let (:one_orphan_result) { one_orphan_importer.extract_orphans }
  let (:three_orphans_result) { three_orphans_importer.extract_orphans }
  let (:three_invalid_orphans_result) { three_invalid_orphans_importer.extract_orphans }
  let (:four_orphans_with_duplicates_result) { four_orphans_with_duplicates_importer.extract_orphans }

  describe '.extract_orphans' do
    it 'should reject opening a non Excel file with an error' do
      importer = OrphanImporter.new('spec/fixtures/not_an_excel_file.txt', @partner)
      result, pending_orphans, import_errors = importer.extract_orphans
      expect(result).to be false
      expect(import_errors[0][:error]).to include('not a valid Excel file')
    end

    it 'should reject opening an empty Excel file' do
      expect(empty_results[2][0][:error]).to include 'Does not contain any orphan records'
      expect(empty_results[0]).to be false
    end

    it 'should reject opening a non Excel file even if it has an Excel extension' do
      importer = OrphanImporter.new('spec/fixtures/fake_excel_file.png.xls', @partner)
      result, pending_orphans, import_errors = importer.extract_orphans
      expect(result).to be false
      expect(import_errors[0][:error]).to include 'not a valid Excel file'
    end

  end

  describe '.extract_orphans' do
    it 'should parse one valid record and return one orphan hash and no errors' do
      expect(one_orphan_result[1].count).to eq 1
      expect(one_orphan_result[0]).to be true
    end

    it 'should parse three valid records and return three orphan hashes and no errors' do
      expect(three_orphans_result[1].count).to eq 3
      expect(three_orphans_result[0]).to be true
    end

    it 'should parse three invalid records and return errors' do
      expect(three_invalid_orphans_result[0]).to eq false
      expect(three_invalid_orphans_result[2].count).to be > 0
    end

    it 'should parse four valid records with duplication and return errors' do
      expect(four_orphans_with_duplicates_result[0]).to be false
      expect(four_orphans_with_duplicates_result[2].count).to be > 0
    end

    it 'should return valid pending orphan objects' do
      [one_orphan_result[1], three_orphans_result[1]].each do |result|
        result.each do |orphan|
          expect(orphan).to be_valid
        end
      end
    end

  end

  describe '#add_import_errors' do
    before :each do
      @ref   = 'ref'
      @error = 'error'
      @hash  = { :ref => @ref, :error => @error }
    end

    it 'will increase import errors by 1 when called' do
      expect{one_orphan_importer.send(:add_import_errors, @ref, @error)}.to \
        change{one_orphan_importer.instance_variable_get(:@import_errors).size}.from(0).to(1)
    end

    specify '@import errors will include a hash of the reference and error when called' do
      one_orphan_importer.send(:add_import_errors, @ref, @error)
      expect(one_orphan_importer.instance_variable_get(:@import_errors)).to \
        include(@hash)
    end
  end

  describe '#import_orphan' do
    let!(:col_count) {one_orphan_importer.instance_variable_get(:@mapper).size}
    let!(:doc) { double("docs") }

    it 'should get a cell and celltype from the spreadsheet' do
      expect(doc).to receive(:cell).exactly(col_count).times
      expect(doc).to receive(:celltype).exactly(col_count).times
      one_orphan_importer.send(:import_orphan, doc, 4)
    end

  end

  describe '#add_to_pending_orphans_if_all_still_ok' do
    it 'increases pending_orphans by 1 if all ok' do
      allow(one_orphan_importer).to receive(:no_errors_found_in_spreadsheet?) { true }
      expect{one_orphan_importer.send(:add_to_pending_orphans_if_all_still_ok,Hash.new)}.
        to change{one_orphan_importer.instance_variable_get(:@pending_orphans).
        size}.from(0).to(1)
    end

    it 'should not change pending orphans if not valid' do
      allow(one_orphan_importer).to receive(:no_errors_found_in_spreadsheet?) { false }
      expect{one_orphan_importer.send(:add_to_pending_orphans_if_all_still_ok,Hash.new)}.
        not_to change{one_orphan_importer.
        instance_variable_get(:@pending_orphans).size}
    end
  end

  specify '#log_exceptions logs to import errors if an error is raised' do
    exception_raiser = lambda { raise ArgumentError }
    expect{one_orphan_importer.send(:log_exceptions, nil, nil, &exception_raiser) }.
     to change{one_orphan_importer.instance_variable_get(:@import_errors).size}.from(0).to(1)
  end
end

