module OrphanAttrFilter
  extend ActiveSupport::Concern

  included do
    extend WhereWithCondition
    self::ActiveRecord_Relation.include WhereWithCondition

    scope :filter, ->(filters) do
      self
        .where_with_conditions(["orphans.name ILIKE ?", "%#{filters[:name_value]}%"], conditions: [filters[:name_value], filters[:name_option]=="contains"])
        .where_with_conditions(["orphans.name ILIKE ?", filters[:name_value]], conditions: [filters[:name_value], filters[:name_option]=="equals"])
        .where_with_conditions(["orphans.name ~* ?", "^#{filters[:name_value]}"], conditions: [filters[:name_value], filters[:name_option]=="starts_with"])
        .where_with_conditions(["orphans.name ~* ?", "#{filters[:name_value]}$"], conditions: [filters[:name_value], filters[:name_option]=="ends_with"])
        .where_with_conditions(["date_of_birth > ?", filters[:date_of_birth_from]], conditions: [filters[:date_of_birth_from]])
        .where_with_conditions(["date_of_birth < ?", filters[:date_of_birth_until]], conditions: [filters[:date_of_birth_until]])
        .where_with_conditions(["orphans.gender ILIKE ?", filters[:gender]], conditions: [filters[:gender]])
        .where_with_conditions(["province_code = ?", filters[:province_code]], conditions: [filters[:province_code]])
        .where_with_conditions(["addresses.city ILIKE ?", filters[:original_address_city]], conditions: [filters[:original_address_city]])
        .where_with_conditions(["priority ILIKE ?", filters[:priority]], conditions: [filters[:priority]])
        .where_with_conditions(["sponsorship_status = ?", filters[:sponsorship_status]], conditions: [filters[:sponsorship_status]])
        .where_with_conditions(["status = ?", filters[:status]], conditions: [filters[:status]])
        .where_with_conditions(["partners.name ILIKE ?", filters[:orphan_list_partner_name]], conditions: [filters[:orphan_list_partner_name]])
        .where_with_conditions(["father_given_name ILIKE ?", "%#{filters[:father_given_name_value]}%"], conditions: [filters[:father_given_name_value], filters[:father_given_name_option]=="contains"])
        .where_with_conditions(["father_given_name ILIKE ?", filters[:father_given_name_value]], conditions: [filters[:father_given_name_value], filters[:father_given_name_option]=="equals"])
        .where_with_conditions(["father_given_name ~* ?", "^#{filters[:father_given_name_value]}"], conditions: [filters[:father_given_name_value], filters[:father_given_name_option]=="starts_with"])
        .where_with_conditions(["father_given_name ~* ?", "#{filters[:father_given_name_value]}$"], conditions: [filters[:father_given_name_value], filters[:father_given_name_option]=="ends_with"])
        .where_with_conditions(["family_name ILIKE ?", "%#{filters[:family_name_value]}%"], conditions: [filters[:family_name_value], filters[:family_name_option]=="contains"])
        .where_with_conditions(["family_name ILIKE ?", filters[:family_name_value]], conditions: [filters[:family_name_value], filters[:family_name_option]=="equals"])
        .where_with_conditions(["family_name ~* ?", "^#{filters[:family_name_value]}"], conditions: [filters[:family_name_value], filters[:family_name_option]=="starts_with"])
        .where_with_conditions(["family_name ~* ?", "#{filters[:family_name_value]}$"], conditions: [filters[:family_name_value], filters[:family_name_option]=="ends_with"])
        .where_with_conditions(["father_is_martyr = ?", filters[:father_is_martyr]], conditions: [filters[:father_is_martyr]])
        .where_with_conditions(["mother_alive = ?", filters[:mother_alive]], conditions: [filters[:mother_alive]])
        .where_with_conditions(["health_status ILIKE ?", filters[:health_status]], conditions: [filters[:health_status]])
        .where_with_conditions(["goes_to_school = ?", filters[:goes_to_school]], conditions: [filters[:goes_to_school]])
        .where_with_conditions(["orphans.created_at > ?", filters[:created_at_from]], conditions: [filters[:created_at_from]])
        .where_with_conditions(["orphans.created_at < ?", filters[:created_at_until]], conditions: [filters[:created_at_until]])
        .where_with_conditions(["orphans.updated_at > ?", filters[:updated_at_from]], conditions: [filters[:updated_at_from]])
        .where_with_conditions(["orphans.updated_at < ?", filters[:updated_at_until]], conditions: [filters[:updated_at_until]])
    end
  end
end
