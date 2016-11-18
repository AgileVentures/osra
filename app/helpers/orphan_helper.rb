module OrphanHelper
  def child_or_adult?(orphan)
    orphan.age_in_years > Orphan::AGE_OF_ADULTHOOD ? "adult" : "child"
  end
end
