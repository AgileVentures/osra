module OrphanHelper
  def active_adult?(orphan)
    "active_adult" if orphan.adult? && orphan.active?
  end
end
