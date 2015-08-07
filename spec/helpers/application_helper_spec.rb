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

  context ':sortable_link', focus: true do
    it 'generates active table header link' do
      expect(self)
        .to receive(:link_to)
        .with("Full Name", {
          :sort_column => "name",
          :sort_direction => "asc",
          :sort_columns_included_resource => "included_resource"
        })
        .and_return("<a>generated_link</a>")

      rendered_link = sortable_link("name", {
          sort_direction: "desc",
          table_header: "Full Name",
          sort_columns_included_resource: "included_resource",
          sort_column_is_active: true
        })

      expect(rendered_link).to include("<a>generated_link</a>")
      expect(rendered_link).to include("<span class=\"glyphicon th_sort_asc\"></span>")
    end

    it 'generates inactive table header link' do
      expect(self)
        .to receive(:link_to)
        .with("Full Name", {
          :sort_column => "name",
          :sort_direction => nil,
          :sort_columns_included_resource => "included_resource"
        })
        .and_return("<a>generated_link</a>")

      rendered_link = sortable_link("name", {
          sort_direction: "desc",
          table_header: "Full Name",
          sort_columns_included_resource: "included_resource",
          sort_column_is_active: false
        })

      expect(rendered_link).to include("<a>generated_link</a>")
      expect(rendered_link).to_not include("<span")
    end
  end
end
