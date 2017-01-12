require "rails_helper"

RSpec.describe TimeHelper, type: :helper do
  describe '#format_full_date' do
    it 'formats a date' do
      expect(format_full_date(Date.parse('1999-12-03'))).to eq '03 December 1999'
    end

    it 'handles nil input' do
      expect(format_full_date(nil)).to eq 'none'
    end
  end

  describe '#format_month_year_date' do
    it 'formats a date' do
      expect(format_month_year_date(Date.parse('1999-12-03'))).to eq '12/1999'
    end

    it 'handles nil input' do
      expect(format_month_year_date(nil)).to eq 'none'
    end
  end

end
