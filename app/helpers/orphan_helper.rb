module OrphanHelper
  def over_18?(orphan)
    orphan.age_in_years > 18 ? "adult" : "child"
  end
end
