class HqController < ApplicationController
  before_action :authenticate_admin_user!
  layout 'application'
end

