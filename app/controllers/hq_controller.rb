class HqController < ApplicationController
  before_filter :authenticate_admin_user!
  layout 'application'
end
