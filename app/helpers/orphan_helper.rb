module OrphanHelper
  def active_adult?(orphan)
    orphan.adult? && orphan.active? ? "active_adult" : ""
  end
end
