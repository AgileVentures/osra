class SponsorFilter < Hash
end

# USE:
# FactoryGirl.build(:sponsor_filter)   to create default sponsor_filter
# FactoryGirl.build(:sponsor_filter, sponsor: FactoryGirl.build_stubbed(:sponsor, name: "AA")) to overwrite attributes
# FactoryGirl.build(:sponsor_filter, name_option: "contains", sponsor: FactoryGirl.create(:sponsor, name: "AA")) to overwrite attributes
FactoryGirl.define do
  factory :sponsor_filter do
    sponsor {build_stubbed :sponsor}

    name_option {"equals"}
    active_sponsorship_count_option {"equals"}

    initialize_with do
      {
        name_option: name_option,
        name_value: sponsor.name,
        gender: sponsor.gender,
        branch_id: sponsor.branch_id,
        organization_id: sponsor.organization_id,
        status_id: sponsor.status_id,
        sponsor_type_id: sponsor.sponsor_type_id,
        agent_id: sponsor.agent_id,
        city: sponsor.city,
        country: sponsor.country,
        created_at_from: sponsor.created_at - 1.day,
        created_at_until: sponsor.created_at + 1.day,
        updated_at_from: sponsor.updated_at ? sponsor.updated_at - 1.day : Date.current - 1.day,
        updated_at_until: sponsor.updated_at ? sponsor.updated_at + 1.day : Date.current + 1.day,
        start_date_from: sponsor.start_date - 1.day,
        start_date_until: sponsor.start_date + 1.day,
        request_fulfilled: sponsor.request_fulfilled,
        active_sponsorship_count_option: active_sponsorship_count_option,
        active_sponsorship_count_value: sponsor.active_sponsorship_count
      }
     end
  end
end
