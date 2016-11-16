class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  NAVIGATION_BUTTONS= [
    { text: 'Dashboard', href: 'dashboard_index_path', path_regex: /^\/dashboard/, glyph: 'glyphicon-dashboard' },
    { text: 'Admin Users', href: 'admin_users_path', path_regex: /^\/admin_users/, glyph: 'glyphicon-user' },
    { text: 'Orphans', href: 'orphans_path', path_regex: /^\/orphans/, glyph: 'glyphicon-user' },
    { text: 'Partners', href: 'partners_path', path_regex: /^\/partners/, glyph: 'glyphicon-user' },
    { text: 'Sponsors', href: 'sponsors_path', path_regex: /^\/sponsors/, glyph: 'glyphicon-user' },
    { text: 'Users', href: 'users_path', path_regex: /^\/users/, glyph: 'glyphicon-user' }
  ]

  before_action :authenticate_admin_user!
end
