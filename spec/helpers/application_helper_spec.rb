require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  context ':format_full_date' do
    it 'formats a date' do
      expect(format_full_date(Date.parse('1999-12-03'))).to eq '03 December 1999'
    end

    it 'handles nil input' do
      expect(format_full_date(nil)).to eq 'none'
    end
  end

  context ':format_month_year_date' do
    it 'formats a date' do
      expect(format_month_year_date(Date.parse('1999-12-03'))).to eq '12/1999'
    end

    it 'handles nil input' do
      expect(format_month_year_date(nil)).to eq 'none'
    end
  end

  context 'set_sort_by_direction' do
    specify ":desc" do
      sort_by_params = {"column" => "osra_num", "direction" => "asc"}
      expect(set_sort_by_direction(:osra_num, sort_by_params)).to eq :desc

      sort_by_params = {"column" => "osra_num", "direction" => "asc"}
      expect(set_sort_by_direction(:osra_num, sort_by_params)).to eq :desc
    end

    specify ":asc" do
      sort_by_params = {"column" => "osra_num", "direction" => "desc"}
      expect(set_sort_by_direction(:osra_num, sort_by_params)).to eq :asc

      sort_by_params = {"column" => "osra_num", "direction" => "desc"}
      expect(set_sort_by_direction(:osra_num, sort_by_params)).to eq :asc
    end
  end


end
