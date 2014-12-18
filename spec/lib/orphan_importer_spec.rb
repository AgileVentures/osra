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
      importer.extract_orphans
      expect(importer).not_to be_valid
      expect(importer.import_errors[0][:error]).to include('not a valid Excel file')
    end

    it 'should open an .xls file with no errors' do
      importer = OrphanImporter.new('spec/fixtures/empty_xls.xls', @partner)
      expect(importer).to be_valid
    end

    it 'should reject opening an empty Excel file' do
      expect(empty_results[0][:error]).to include 'Does not contain any orphan records'
      expect(empty_importer).not_to be_valid
    end

    it 'should reject opening a non Excel file even if it has an Excel extension' do
      importer = OrphanImporter.new('spec/fixtures/fake_excel_file.png.xls', @partner)
      importer.extract_orphans
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

    it 'should parse four valid records with duplication and return errors' do
      expect(four_orphans_with_duplicates_result).not_to be_empty
      expect(four_orphans_with_duplicates_importer).not_to be_valid
    end

    it 'should return valid pending orphan objects' do
      [one_orphan_result, three_orphans_result].each do |result|
        result.each do |orphan|
          expect(orphan).to be_valid
        end
      end
    end

  end

  describe '#valid?' do
    it 'will return true if there are no import errors' do
      one_orphan_importer.instance_variable_set(:@import_errors, [])
      expect(one_orphan_importer.valid?).to be true
    end

    it 'will return false if there are import errors' do
      one_orphan_importer.instance_variable_set(:@import_errors, ["has errors"])
      expect(one_orphan_importer.valid?).to be false
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

  describe '#process_column' do
    let(:record) { double('record') }
    let(:column) do
      double('column',
             :column => 'column',
             :field  => 'field')
    end

    it 'will return an Integer if the column type is an integer' do
      expect(column).to receive(:mandatory).and_return("false")
      expect(column).to receive(:type).and_return('Integer')
      expect(one_orphan_importer.send(:process_column, record, column, "8")).to eq 8
    end

    it 'will return a String if the column type is a string' do
      expect(column).to receive(:type).and_return("String")
      expect(one_orphan_importer.send(:process_column, record,
                                      column, "String Value")).to eq "String Value"
    end

    it 'will return a Date if the column type is a date' do
      date = Date.current
      expect(column).to receive(:mandatory).and_return("false")
      expect(column).to receive(:type).and_return("Date")
      expect(one_orphan_importer.send(:process_column, record,
                                      column, "#{date}")).to eq date
    end
  end

  describe '#error_or_orphans' do
    let(:errors) {['errors']}
    let(:orphans) {['orphans']}

    before :each do
      one_orphan_importer.instance_variable_set(:@pending_orphans, orphans)
    end

    it 'will return orphans if valid' do
      expect(one_orphan_importer.error_or_orphans).to eq orphans
    end

    it 'will return errors if not valid' do
      expect(one_orphan_importer.error_or_orphans).to eq orphans
    end
  end

  specify '#import_orphans' do
    doc = double( "doc", :last_row => 6)
    expect(one_orphan_importer).to receive(:import_orphan).exactly(3).times
    one_orphan_importer.import_orphans(doc)
  end

  describe '#import_orphan' do
    let!(:col_count) {Settings.import.columns.size}
    let!(:doc) { double("docs") }

    it 'should get a cell from the spreadsheet' do
      expect(doc).to receive(:cell).exactly(col_count).times
      one_orphan_importer.import_orphan(doc, 4)
    end

    it 'should call #process_columan' do
      expect(doc).to receive(:cell).exactly(col_count).times
      expect(one_orphan_importer).to receive(:process_column).
        exactly(col_count).times
      one_orphan_importer.import_orphan(doc, 4)
    end
  end

  describe '#add_to_pending_orphan_if_valid' do
    it 'increases pending_orphans by 1 if valid' do
      expect(one_orphan_importer).to receive(:valid?).and_return(true)
      expect{one_orphan_importer.add_to_pending_orphans_if_valid(Hash.new)}.
        to change{one_orphan_importer.instance_variable_get(:@pending_orphans).
        size}.from(0).to(1)
    end

    it 'should not change pending orphans if not valid' do
      expect(one_orphan_importer).to receive(:valid?).and_return(false)
      expect{one_orphan_importer.add_to_pending_orphans_if_valid(Hash.new)}.
        not_to change{one_orphan_importer.
        instance_variable_get(:@pending_orphans).size}
    end
  end

  describe '#process_column' do
    let(:col_settings) {double "col_settings", field: "name",
                        column: "B", mandatory: false}

    it 'creates a new instance of a DataColumn subclass' do
      expect(col_settings).to receive(:type).and_return("String")
      expect(ImportOrphanSettings::StringColumn).to receive(:new)
      one_orphan_importer.process_column(4, col_settings, "Y")
    end
  end

  specify '#log_exceptions logs to import errors if an error is raised' do
    expect{one_orphan_importer.log_exceptions {raise ArgumnetError} }.
     to change{one_orphan_importer.import_errors.size}.from(0).to(1)
  end
end

