require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  context ':sortable_link' do
    it 'generates active table header link' do
      expect(self).to receive_message_chain(:request, :query_parameters).and_return({})
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
      expect(self).to receive_message_chain(:request, :query_parameters).and_return({})
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
      expect(rendered_link).to include("<div class='asc_desc'>")
    end
  end
end
