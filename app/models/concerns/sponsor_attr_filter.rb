module SponsorAttrFilter
  extend ActiveSupport::Concern

  included do
    extend WhereWithCondition
    self::ActiveRecord_Relation.include WhereWithCondition

    scope :filter, ->(filters) do
      self
        .where_with_conditions(["name ILIKE ?", "%#{filters[:name_value]}%"], conditions: [filters[:name_value], filters[:name_option]=="contains"])
        .where_with_conditions(["name ILIKE ?", filters[:name_value]], conditions: [filters[:name_value], filters[:name_option]=="equals"])
        .where_with_conditions(["name ~* ?", "^#{filters[:name_value]}"], conditions: [filters[:name_value], filters[:name_option]=="starts_with"])
        .where_with_conditions(["name ~* ?", "#{filters[:name_value]}$"], conditions: [filters[:name_value], filters[:name_option]=="ends_with"])
        .where_with_conditions(["gender LIKE ?", filters[:gender]], conditions: [filters[:gender]])
        .where_with_conditions(["branch_id = ?", filters[:branch_id]], conditions: [filters[:branch_id]])
        .where_with_conditions(["organization_id = ?", filters[:organization_id]], conditions: [filters[:organization_id]])
        .where_with_conditions(["status_id = ?", filters[:status_id]], conditions: [filters[:status_id]])
        .where_with_conditions(["sponsor_type_id = ?", filters[:sponsor_type_id]], conditions: [filters[:sponsor_type_id]])
        .where_with_conditions(["agent_id = ?", filters[:agent_id]], conditions: [filters[:agent_id]])
        .where_with_conditions(["city LIKE ?", filters[:city]], conditions: [filters[:city]])
        .where_with_conditions(["country LIKE ?", filters[:country]], conditions: [filters[:country]])
        .where_with_conditions(["created_at > ?", filters[:created_at_from]], conditions: [filters[:created_at_from]])
        .where_with_conditions(["created_at < ?", filters[:created_at_until]], conditions: [filters[:created_at_until]])
        .where_with_conditions(["updated_at > ?", filters[:updated_at_from]], conditions: [filters[:updated_at_from]])
        .where_with_conditions(["updated_at < ?", filters[:updated_at_until]], conditions: [filters[:updated_at_until]])
        .where_with_conditions(["start_date > ?", filters[:start_date_from]], conditions: [filters[:start_date_from]])
        .where_with_conditions(["start_date < ?", filters[:start_date_until]], conditions: [filters[:start_date_until]])
        .where_with_conditions(["request_fulfilled = ?", filters[:request_fulfilled]], conditions: [filters[:request_fulfilled]])
        .where_with_conditions(["active_sponsorship_count = ?", filters[:active_sponsorship_count_value]], conditions: [filters[:active_sponsorship_count_value], filters[:active_sponsorship_count_option]=="equals"])
        .where_with_conditions(["active_sponsorship_count > ?", filters[:active_sponsorship_count_value]], conditions: [filters[:active_sponsorship_count_value], filters[:active_sponsorship_count_option]=="greather_than"])
        .where_with_conditions(["active_sponsorship_count < ?", filters[:active_sponsorship_count_value]], conditions: [filters[:active_sponsorship_count_value], filters[:active_sponsorship_count_option]=="less_than"])
    end
  end
end
