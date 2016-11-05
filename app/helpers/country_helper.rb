module CountryHelper
  def country_options_for_select
    Sponsor.distinct.pluck(:country).each_with_object({}) do |c, h|
      h[ISO3166::Country[c].name] = c
    end
  end
end
