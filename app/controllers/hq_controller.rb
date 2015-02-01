class HqController < ApplicationController
  NAVIGATION_BUTTONS= {
    osra: { text: 'OSRA', href: 'root_path', path_regex: /^\/$/, glyph: 'glyphicon-home' },
    dashboard: { text: 'Dashboard', href: '"/404.html"', path_regex: /^\/hq(\/)?$/, glyph: 'glyphicon-dashboard' },
    admin_users: { text: 'Admin Users', href: '"/404.html"', path_regex: /^\/hq\/admin_users/, glyph: 'glyphicon-user' },
    comments: { text: 'Comments', href: '"/404.html"', path_regex: /^\/hq\/comments/, glyph: 'glyphicon-comment' },
    orphans: { text: 'Orphans', href: '"/404.html"', path_regex: /^\/hq\/orphans/, glyph: 'glyphicon-user' },
    partners: { text: 'Partners', href: 'hq_partners_path', path_regex: /^\/hq\/partners/, glyph: 'glyphicon-user' },
    sponsors: { text: 'Sponsors', href: 'hq_sponsors_path', path_regex: /^\/hq\/sponsors/, glyph: 'glyphicon-user' },
    users: { text: 'Users', href: 'hq_users_path', path_regex: /^\/hq\/users/, glyph: 'glyphicon-user' }
  }

  before_action :authenticate_admin_user!
  layout 'application'
end

