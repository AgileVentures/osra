require 'rails_helper'
require 'excel_upload'

describe ExcelUpload do
  before :each do
    @first_row = OrphanImporter.class_variable_get(:@@first_row)
  end

  describe '.upload' do
    it 'should reject opening a non Excel file with an error' do
      expect{ExcelUpload.upload('spec/fixtures/not_an_excel_file.txt',
        @first_row)}.to raise_error
    end

    it 'should open an .xls file with no errors' do
      expect{ExcelUpload.upload('spec/fixtures/one_orphan_xls.xls',
        @first_row)}.not_to raise_error
    end

    it 'should reject opening an empty Excel file' do
      expect{ExcelUpload.upload('spec/fixtures/empty_xls.xls',
        @first_row)}.to raise_error
    end

    it 'should reject opening a non Excel file even if it has an Excel extension' do
      expect{ExcelUpload.upload('spec/fixtures/fake_excel_file.png.xls',
        @first_row)}.to raise_error
    end
  end

  describe '.extension' do
    it 'should return .xls for a file ending in .xls' do
      expect(ExcelUpload.extension('file.xls')).to eq 'xls'
    end

    it 'should return the last extension for files with multiples extensions' do
      expect(ExcelUpload.extension('file.png.txt')).to eq 'txt'
    end
  end

  describe '.empty_file?' do
    it 'should return true for a file without orphan records' do
      doc = Roo::Spreadsheet.open('spec/fixtures/empty_xls.xls')
      expect(ExcelUpload.empty_file?(doc, @first_row)).to be true
    end

    it 'should return false for a file with orphan records' do
      doc = Roo::Spreadsheet.open('spec/fixtures/one_orphan_xls.xls')
      expect(ExcelUpload.empty_file?(doc, @first_row)).to be false
    end
  end
end
