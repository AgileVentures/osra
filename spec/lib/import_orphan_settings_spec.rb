require 'rails_helper'
require 'import_orphan_settings'

describe ImportOrphanSettings do
  let(:settings) { double("settings") }

  describe '.settings' do
    it 'should return rails settings' do
      expect(ImportOrphanSettings.settings).to eq Settings.import
    end
  end

  context '::DataColumn and its subclasses' do
    specify '#class_name should return the class name' do
      expect(ImportOrphanSettings::StringColumn.new(nil, nil).class_name).to\
        eq 'StringColumn'
    end

    specify '#data_type should return the class name' do
      expect(ImportOrphanSettings::StringColumn.new(nil, nil).data_type).to\
        eq 'string'
    end

    specify '#options should return the options for the data type' do
      expect(ImportOrphanSettings::StringColumn.new(nil, nil).options).to\
        eq Settings.import['string']
    end

    specify '#has_options? is true if options for the type exist' do
      expect(ImportOrphanSettings::BooleanColumn.new(nil, nil).has_options?).to\
        be true
    end

    specify '#has_options? is false if options for the type do not exist' do
      expect(ImportOrphanSettings::StringColumn.new(nil, nil).has_options?).to\
        be false
    end

    specify '#mandatory? is false if options for the type are not mandatory' do
      expect(settings).to receive(:mandatory).and_return(false)
      expect(ImportOrphanSettings::StringColumn.new(nil, settings).mandatory?).to\
        be false
    end

    specify '#mandatory? is true if options for the type are mandatory' do
      expect(settings).to receive(:mandatory).and_return(true)
      expect(ImportOrphanSettings::StringColumn.new(nil, settings).mandatory?).to\
        be true
    end

    specify '#permitted_options gives allowable options for the excel cell' do
      expect(ImportOrphanSettings::BooleanColumn.new(nil, settings).
        permitted_options).to eq ["Y", "N"]
    end

    context "#valid option?" do
      specify 'accepts all valid options' do
        expect(settings).to receive(:mandatory).at_least(:once).and_return(true)
        ["Y", "N"].each do |val|
          expect(ImportOrphanSettings::BooleanColumn.new(val, settings).
            valid_option?).to eq true
        end
      end

      specify 'accepts nil if not mandatory' do
        expect(settings).to receive(:mandatory).and_return(false)
        expect(ImportOrphanSettings::BooleanColumn.new(nil, settings).
          valid_option?).to eq true
      end

      specify 'does not accept invalid options' do
        expect(settings).to receive(:mandatory).at_least(:once).and_return(true)
        ["string", "true"].each do |val|
          expect(ImportOrphanSettings::BooleanColumn.new(val, settings).
            valid_option?).to eq false
        end
      end
    end

    context "#to_val" do
      specify "ordinarily just returns a string representation of the value" do
        expect(ImportOrphanSettings::BooleanColumn.new("Y", settings).
          to_val).to eq "Y"
      end

      specify "DateColumn returns a date representation of the value" do
        date = Date.parse ('2014-08-08')
        expect(settings).to receive(:mandatory).and_return(true)
        expect(ImportOrphanSettings::DateColumn.new("2014-08-08", settings).
          to_val).to eq date
      end

      specify "DateColumn raises an error with an invalid date" do
        expect{ImportOrphanSettings::DateColumn.new("not a date", settings).
          to_val}.to raise_error
      end

      specify "IntegerColumn returns an int representation of the value" do
        expect(settings).to receive(:mandatory).and_return(true)
        expect(ImportOrphanSettings::IntegerColumn.new("7", settings).
          to_val).to eq 7
      end
    end

    specify ".convert_option_value will translate a cell input to a db output" do
      expect(ImportOrphanSettings::BooleanColumn.new("Y", settings).
        convert_option_value).to be true
    end

    context ".parse_value" do
      specify "it will return its value if no options are present" do
        expect(ImportOrphanSettings::StringColumn.new("Fred", nil).
          parse_value).to eq "Fred"
      end

      specify "it will return a converted value if options are present" do
        expect(settings).to receive(:mandatory).and_return(true)
        expect(ImportOrphanSettings::BooleanColumn.new("Y", settings).
          parse_value).to be true
      end

      specify "it will raise an error if options are present but not valid"  do
        expect(settings).to receive(:mandatory).and_return(false)
        expect{ImportOrphanSettings::BooleanColumn.new("no", settings).
          parse_value}.to raise_error
      end
    end
  end
end
