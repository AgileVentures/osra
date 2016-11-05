class OrphanListsController < ApplicationController

  def index
    @partner = Partner.find(params[:partner_id])
    @orphan_lists = @partner.orphan_lists
  end

end
