module FeatureHelpers
  module Factories
    def given_partners_exist table
      table.each do |hash|
        status = Status.find_by_name(hash[:status])
        province = Province.find_by_name(hash[:province])
        partner = Partner.new(name: hash[:name],
                              region: hash[:region],
                              start_date: hash[:start_date],
                              contact_details: hash[:contact_details],
                              province: province,
                              status: status)
        partner.save!
      end
    end

  end
end
