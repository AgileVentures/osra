module FeatureHelpers
  module Navigation
    def and_i_should_be_on page, field_hash = {}
      if field_hash.empty?
        get_path page
        return
      end
      case field_hash.keys.first.to_sym
        when :sponsor_name
          sponsor = Sponsor.find_by(name: field_hash[:sponsor_name])
          get_path page, sponsor.id
        when :sponsor_id
          get_path page, field_hash[:sponsor_id]
        else raise('path to specified object is not displayed')
      end
    end

    def get_path page, object_id = ''
      page_path = case page.to_sym
                    when :root_page then hq_root_path
                    when :sign_in_page then new_hq_admin_user_session_path
                    when :new_sponsor_page then new_hq_sponsor_path
                    when :hq_sponsor_path then hq_sponsor_path object_id
                    when :hq_new_sponsorship_path then hq_new_sponsorship_path object_id
                    else raise('path to specified is not listed in #path_to')
                  end

      expect(current_path).to eq page_path
    end

    def and_i_click_button button
      click_button button
    end

    def and_i_should_see text
      expect(page).to have_text text
    end

    def and_i_should_not_see text
      expect(page).not_to have_text text
    end
  end
end
