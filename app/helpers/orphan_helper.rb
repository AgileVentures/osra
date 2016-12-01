module OrphanHelper
  def orphan_highlight_class(orphan)
    "active_adult" if orphan.adult? && orphan.active?
  end
end
