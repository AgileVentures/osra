module SponsorAttrFilter
  extend ActiveSupport::Concern

  module WhereWithCondition
    def where_with_condition querry=[], conditions=[]
      conditions_valid = conditions.all? {|c| c ? true : false}
      conditions_valid ? self.where(querry) : self
    end
  end
  Sponsor.extend WhereWithCondition
  Sponsor::ActiveRecord_Relation.include WhereWithCondition

  included do
    scope :filter, ->(filters) do
      self
        .where_with_condition(["name ILIKE ?", "%#{filters[:name_value]}%"], [filters[:name_value], filters[:name_option]=="contains"])
        .where_with_condition(["name ILIKE ?", filters[:name_value]], [filters[:name_value], filters[:name_option]=="equals"])
        .where_with_condition(["name ~ ?", "^#{filters[:name_value]}"], [filters[:name_value], filters[:name_option]=="starts_with"])
        .where_with_condition(["name ~ ?", "#{filters[:name_value]}$"], [filters[:name_value], filters[:name_option]=="ends_with"])
        .where_with_condition(["gender LIKE ?", filters[:gender]], [filters[:gender]])
        .where_with_condition(["branch_id = ?", filters[:branch_id]], [filters[:branch_id]])
        .where_with_condition(["organization_id = ?", filters[:organization_id]], [filters[:organization_id]])
        .where_with_condition(["status_id = ?", filters[:status_id]], [filters[:status_id]])
        .where_with_condition(["sponsor_type_id = ?", filters[:sponsor_type_id]], [filters[:sponsor_type_id]])
        .where_with_condition(["agent_id = ?", filters[:agent_id]], [filters[:agent_id]])
        .where_with_condition(["city LIKE ?", filters[:city]], [filters[:city]])
        .where_with_condition(["country LIKE ?", filters[:country]], [filters[:country]])
        .where_with_condition(["created_at > ?", filters[:created_at_from]], [filters[:created_at_from]])
        .where_with_condition(["created_at < ?", filters[:created_at_until]], [filters[:created_at_until]])
        .where_with_condition(["updated_at > ?", filters[:updated_at_from]], [filters[:updated_at_from]])
        .where_with_condition(["updated_at < ?", filters[:updated_at_until]], [filters[:updated_at_until]])
        .where_with_condition(["start_date > ?", filters[:start_date_from]], [filters[:start_date_from]])
        .where_with_condition(["start_date < ?", filters[:start_date_until]], [filters[:start_date_until]])
        .where_with_condition(["request_fulfilled = ?", filters[:request_fulfilled]], [filters[:request_fulfilled]])
        .where_with_condition(["active_sponsorship_count = ?", filters[:active_sponsorship_count_value]], [filters[:active_sponsorship_count_value], filters[:active_sponsorship_count_option]=="equals"])
        .where_with_condition(["active_sponsorship_count > ?", filters[:active_sponsorship_count_value]], [filters[:active_sponsorship_count_value], filters[:active_sponsorship_count_option]=="greather_than"])
        .where_with_condition(["active_sponsorship_count < ?", filters[:active_sponsorship_count_value]], [filters[:active_sponsorship_count_value], filters[:active_sponsorship_count_option]=="less_than"])
    end
  end
end
