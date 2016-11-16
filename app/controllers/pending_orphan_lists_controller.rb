class PendingOrphanListsController < ApplicationController

  def upload
    get_partner

    unless @partner.active?
      flash[:error] = 'Partner is not Active. Orphan List cannot be uploaded.'
      redirect_to partner_path(@partner)
      return
    end
  end

  def validate
    get_partner

    unless @partner.active?
      flash[:alert] = 'Partner is not Active. Orphan List cannot be uploaded.'
      redirect_to partner_path(@partner)
      return
    end

    if params['pending_orphan_list'].nil?  # no spreadsheet has been specified
      flash[:error] = 'Please specify the spreadsheet to be uploaded'
      redirect_to upload_partner_pending_orphan_lists_path(@partner)
      return
    end

    @pending_orphan_list = PendingOrphanList.new(pending_orphan_list_params)
    importer = OrphanImporter.new(params['pending_orphan_list']['spreadsheet'], @partner)
    result = importer.extract_orphans

    if importer.valid?
      @pending_orphan_list.pending_orphans = result
      @pending_orphan_list.save!
      to_render = :valid_list
    else
      to_render = :invalid_list
    end

    render action: to_render,
           locals: { partner:             @partner,
                     orphan_list:         @partner.orphan_lists.build,
                     pending_orphan_list: @pending_orphan_list,
                     result:              result }
  end

  def import
    get_partner
    get_pending_orphan_list
    orphan_list  = @partner.orphan_lists.create!(spreadsheet:  @pending_orphan_list.spreadsheet,
                                               orphan_count: 0)
    @pending_orphan_list.pending_orphans.each do |pending_orphan|
      orphan = pending_orphan.to_orphan
      orphan_list.orphans << orphan
    end

    orphan_list.save!

    @pending_orphan_list.destroy
    flash[:notice] = "Orphan List (#{orphan_list.osra_num}) was successfully imported.
                      Registered #{orphan_list.orphan_count}
                      new #{'orphan'.pluralize orphan_list.orphan_count}."
    redirect_to partner_path(@partner)
  end

  def destroy
    pending_orphan_list = PendingOrphanList.find(params[:id])
    pending_orphan_list.destroy!
    redirect_to partner_path(params[:partner_id]), alert: 'Orphan List was not imported.'
  end

private

  def get_partner
    @partner = Partner.find(params[:partner_id])
  end

  def pending_orphan_list_params
    params.require(:pending_orphan_list).permit(:spreadsheet)
  end

  def get_pending_orphan_list
    @pending_orphan_list = PendingOrphanList.find(params[:orphan_list][:pending_id])
  end

end
