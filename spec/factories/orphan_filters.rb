class OrphanFilter < Hash
end

# USE:
# FactoryGirl.build(:orphan_filter)   to create default orphan_filter
# FactoryGirl.build(:orphan_filter, orphan: FactoryGirl.build_stubbed(:orphan, name: "AA")) to overwrite attributes
# FactoryGirl.build(:orphan_filter, name_option: "contains", orphan: FactoryGirl.create(:orphan, name: "AA")) to overwrite attributes
FactoryGirl.define do
  factory :orphan_filter do
    orphan {build_stubbed :orphan_full}

    name_option {"equals"}
    father_given_name_option {"equals"}
    family_name_option {"equals"}

    initialize_with do
      {
        name_option: name_option,
        name_value: orphan.name,
        date_of_birth_from: orphan.date_of_birth ? orphan.date_of_birth.to_date - 1.day : Date.current - 2.day,
        date_of_birth_until: orphan.date_of_birth ? orphan.date_of_birth.to_date + 1.day : Date.current - 1.day,
        gender: orphan.gender,
        province_code: orphan.province_code,
        original_address_city: orphan.original_address.city,
        priority: orphan.priority,
        sponsorship_status: orphan.sponsorship_status,
        status: orphan.status,
        orphan_list_partner_name: orphan.orphan_list.partner.name,
        father_given_name_option: father_given_name_option,
        father_given_name_value: orphan.father_given_name,
        family_name_option: family_name_option,
        family_name_value: orphan.family_name,
        father_is_martyr: orphan.father_is_martyr,
        mother_alive: orphan.mother_alive,
        health_status: orphan.health_status,
        goes_to_school: orphan.goes_to_school,
        created_at_from: orphan.created_at.to_date - 1.day,
        created_at_until: orphan.created_at.to_date + 1.day,
        updated_at_from: orphan.updated_at ? orphan.updated_at.to_date - 1.day : Date.current - 1.day,
        updated_at_until: orphan.updated_at ? orphan.updated_at.to_date + 1.day : Date.current + 1.day,
      }
     end
  end
end
