class RailsController < ApplicationController
  before_filter :authenticate_admin_user!
  layout 'application'
end
