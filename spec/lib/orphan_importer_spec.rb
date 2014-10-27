require 'rails_helper'
require 'orphan_importer'

describe OrphanImporter do

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
          orphan             = OrphanImporter.to_orphan fields
          orphan.orphan_list = create :orphan_list
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

  describe '#add_validation_error' do
    before :each do
      @ref   = 'ref'
      @error = 'error'
      @hash  = { :ref => @ref, :error => @error }
    end

    it 'must return false' do
      expect(one_orphan_importer.send(:add_validation_error, @ref, @error)).to be false
    end

    it 'will increase import errors by 1 when called' do
      expect { one_orphan_importer.send(:add_validation_error, @ref, @error) }.to \
        change { one_orphan_importer.instance_variable_get(:@import_errors).size }.from(0).to(1)
    end

    specify '@import errors will include a hash of the reference and error when called' do
      one_orphan_importer.send(:add_validation_error, @ref, @error)
      expect(one_orphan_importer.instance_variable_get(:@import_errors)).to \
        include(@hash)
    end
  end

  describe '#process_option' do
    it 'must check the option is defined' do
      expect(one_orphan_importer).to receive(:option_defined?).with('boolean').and_return(true)
      one_orphan_importer.send(:process_option, 'record', 'column', 'boolean', 'Y')
    end

    it 'must return nil if the option is not defined' do
      expect(one_orphan_importer).to receive(:option_defined?).with('boolean').and_return(false)
      expect(one_orphan_importer.send(:process_option, 'record', 'column',
                                      'boolean', 'Y')).to be_nil
    end

    context "when the yaml db setting is defined" do
      before :each do
        @return_val  = 'result'
        @config_hash = { :db => @return_val }
        expect(one_orphan_importer).to receive(:option_defined?).and_return(true)
        expect(Settings.import).to receive_message_chain(:options,
                                                         '[]', :find).and_return(@config_hash)
      end

      it 'should return the yaml db setting' do
        expect(one_orphan_importer.send(:process_option, 'record', 'column',
                                        'boolean', 'Y')).to eq(@return_val)
      end

      it 'should not add an error' do
        expect { one_orphan_importer.send(:process_option, 'record', @column, 'boolean', 'Y') }.not_to \
          change { one_orphan_importer.instance_variable_get(:@import_errors).size }
      end
    end

    context 'when the yaml db setting is not defined' do
      before :each do
        @column    = double 'column'
        @col_val   = 'column'
        @field_val = 'field_val'
        @record    = 'record'
        @option    = 'boolean'
        @val       = 'Y'
        expect(@column).to receive(:column).and_return(@col_val)
        expect(@column).to receive(:field).and_return(@field_val)
        expect(one_orphan_importer).to receive(:option_defined?).and_return(true)
        expect(Settings.import).to receive_message_chain(:options,
                                                         '[]', :find).and_return(nil)
      end

      it 'must return false' do
        expect(one_orphan_importer.send(:process_option, @record, @column,
                                        @option, @val)).to be false
      end

      it 'must add an error to import errors' do
        expect { one_orphan_importer.send(:process_option, @record, @column, @option, @val) }.to \
          change { one_orphan_importer.instance_variable_get(:@import_errors).size }.from(0).to(1)
      end

      it 'must record the right column and message' do
        expect(one_orphan_importer).to receive(:add_validation_error).with(
                                           "(#{@record},#{@col_val})", "Option value: #{@val} is not defined for field: #{@field_val}")
        one_orphan_importer.send(:process_option, @record, @column, @option, @val)
      end
    end
  end

  describe '#add_error_if_mandatory' do
    let(:column) do
      double("column",
             :column => 'column',
             :field  => 'field')
    end

    before :each do
      @import_errors = one_orphan_importer.instance_variable_get(:@import_errors)
    end
    it 'should add an error if the column is mandatory' do
      expect(column).to receive(:mandatory).and_return(true)
      expect { one_orphan_importer.send(:add_error_if_mandatory, 'record', column) }.to \
        change { @import_errors.size }.from(0).to(1)
    end

    it 'will have no errors if the column is not mandatory' do
      expect(column).to receive(:mandatory).and_return(false)
      one_orphan_importer.send(:add_error_if_mandatory, 'record', column)
      expect { @import_errors.size }.not_to change { @import_errors.size }
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
      expect(column).to receive(:type).and_return("Date")
      expect(one_orphan_importer.send(:process_column, record,
                                      column, "#{date}")).to eq date
    end

    it 'will call #process_options if the column type is an options type' do
      expect(column).to receive(:type).and_return("custom options")
      expect(one_orphan_importer).to receive(:process_option)
      one_orphan_importer.send(:process_column, record, column, "Custom Value")
    end

    it 'will add an error if the column type is a date but no date is given' do
      expect(column).to receive(:type).twice.and_return("Date")
      expect(one_orphan_importer).to receive(:add_validation_error).with(
                                         "(#{record},#{column.column})", anything).and_call_original
      expect { one_orphan_importer.send(:process_column, record, column, "Not a Date") }.to \
        change { one_orphan_importer.instance_variable_get(:@import_errors).size }.from(0).to(1)
    end

    it 'will add an error if the column type is not recognised' do
      expect(column).to receive(:type).twice.and_return("unknown")
      expect(one_orphan_importer).to receive(:add_validation_error).with(
                                         "Import configuration", anything).and_call_original
      expect { one_orphan_importer.send(:process_column, record, column, "unknown") }.to \
        change { one_orphan_importer.instance_variable_get(:@import_errors).size }.from(0).to(1)
    end
  end

  describe '#extract' do
    let(:column) do
      double("column",
             :column => 'column',
             :field  => 'name',
             :type   => 'String')
    end
    let(:doc) { double("doc") }

    before :each do
      expect(Settings.import).to receive(:columns).and_return([column])
    end

    it 'must check if the field is mandatory when the field value is nil' do
      allow(doc).to receive(:cell).with('record', column.column).and_return(nil)
      expect(one_orphan_importer).to receive(:add_error_if_mandatory)
      one_orphan_importer.instance_variable_set(:@doc, doc)
      one_orphan_importer.send(:extract, 'record')
    end

    it 'should process the record if the field has a value' do
      allow(doc).to receive(:cell).with('record', column.column).and_return('value')
      expect(one_orphan_importer).to receive(:process_column)
      one_orphan_importer.instance_variable_set(:@doc, doc)
      one_orphan_importer.send(:extract, 'record')
    end

    context "when the fields have been extracted" do
      before :each do
        allow(doc).to receive(:cell).with('record', column.column).and_return('value')
        expect(one_orphan_importer).to receive(:process_column)
        one_orphan_importer.instance_variable_set(:@doc, doc)
      end

      it 'should try to create a new PendingOrphan' do
        expect(PendingOrphan).to receive(:new)
        one_orphan_importer.send(:extract, 'record')
      end

      it 'should see if the import is valid' do
        expect(one_orphan_importer).to receive(:valid?)
        one_orphan_importer.send(:extract, 'record')
      end

      it 'should increase the @pending_orphans size by 1' do
        expect { one_orphan_importer.send(:extract, 'record') }.to \
         change { one_orphan_importer.instance_variable_get(:@pending_orphans).size }.from(0).to(1)
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