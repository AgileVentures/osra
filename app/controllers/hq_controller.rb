class HqController < ApplicationController
  NAVIGATION_BUTTONS= [
    { text: 'OSRA', href: 'root_path', path_regex: /^\/$/, glyph: 'glyphicon-home' },
    { text: 'Dashboard', href: '"/404.html"', path_regex: /^\/hq(\/)?$/, glyph: 'glyphicon-dashboard' },
    { text: 'Admin Users', href: '"/404.html"', path_regex: /^\/hq\/admin_users/, glyph: 'glyphicon-user' },
    { text: 'Orphans', href: 'hq_orphans_path', path_regex: /^\/hq\/orphans/, glyph: 'glyphicon-user' },
    { text: 'Partners', href: 'hq_partners_path', path_regex: /^\/hq\/partners/, glyph: 'glyphicon-user' },
    { text: 'Sponsors', href: 'hq_sponsors_path', path_regex: /^\/hq\/sponsors/, glyph: 'glyphicon-user' },
    { text: 'Users', href: 'hq_users_path', path_regex: /^\/hq\/users/, glyph: 'glyphicon-user' }
  ]

  before_action :authenticate_admin_user!
  layout 'application'
end

