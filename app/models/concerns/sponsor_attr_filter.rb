module SponsorAttrFilter
  extend ActiveSupport::Concern

  included do
    scope :filter, ->(filters) do
      _Sponsor = self
      _Sponsor = _Sponsor.where("name ILIKE ?", "%#{filters[:name_value]}%") if (filters[:name_value] && filters[:name_option]=="contains")
      _Sponsor = _Sponsor.where("name ILIKE ?", filters[:name_value]) if (filters[:name_value] && filters[:name_option]=="equals")
      _Sponsor = _Sponsor.where("name ~ ?", "^#{filters[:name_value]}") if (filters[:name_value] && filters[:name_option]=="starts_with")
      _Sponsor = _Sponsor.where("name ~ ?", "#{filters[:name_value]}$") if (filters[:name_value] && filters[:name_option]=="ends_with")

      _Sponsor = _Sponsor.where("gender LIKE ?", filters[:gender]) if filters[:gender]
      _Sponsor = _Sponsor.where("branch_id = ?", filters[:branch_id]) if filters[:branch_id]
      _Sponsor = _Sponsor.where("organization_id = ?", filters[:organization_id]) if filters[:organization_id]
      _Sponsor = _Sponsor.where("status_id = ?", filters[:status_id]) if filters[:status_id]
      _Sponsor = _Sponsor.where("sponsor_type_id = ?", filters[:sponsor_type_id]) if filters[:sponsor_type_id]
      _Sponsor = _Sponsor.where("agent_id = ?", filters[:agent_id]) if filters[:agent_id]
      _Sponsor = _Sponsor.where("city LIKE ?", filters[:city]) if filters[:city]
      _Sponsor = _Sponsor.where("country LIKE ?", filters[:country]) if filters[:country]

      _Sponsor = _Sponsor.where("created_at > ?", filters[:created_at_from]) if filters[:created_at_from]
      _Sponsor = _Sponsor.where("created_at < ?", filters[:created_at_until]) if filters[:created_at_until]
      _Sponsor = _Sponsor.where("updated_at > ?", filters[:updated_at_from]) if filters[:updated_at_from]
      _Sponsor = _Sponsor.where("updated_at < ?", filters[:updated_at_until]) if filters[:updated_at_until]
      _Sponsor = _Sponsor.where("start_date > ?", filters[:start_date_from]) if filters[:start_date_from]
      _Sponsor = _Sponsor.where("start_date < ?", filters[:start_date_until]) if filters[:start_date_until]

      _Sponsor = _Sponsor.where("request_fulfilled = ?", filters[:request_fulfilled]) if filters[:request_fulfilled]

      _Sponsor = _Sponsor.where("active_sponsorship_count = ?", filters[:active_sponsorship_count_value]) if (filters[:active_sponsorship_count_value] && filters[:active_sponsorship_count_option]=="equals")
      _Sponsor = _Sponsor.where("active_sponsorship_count > ?", filters[:active_sponsorship_count_value]) if (filters[:active_sponsorship_count_value] && filters[:active_sponsorship_count_option]=="greather_than")
      _Sponsor = _Sponsor.where("active_sponsorship_count < ?", filters[:active_sponsorship_count_value]) if (filters[:active_sponsorship_count_value] && filters[:active_sponsorship_count_option]=="less_than")
      _Sponsor
    end
  end

end