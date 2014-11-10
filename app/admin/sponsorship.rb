ActiveAdmin.register Sponsorship do
  menu if: proc { false }
  actions :create
  belongs_to :sponsor

  form do
    panel 'Sponsor' do
      h3 sponsorship.sponsor_name
      para link_to 'Return to Sponsor page', admin_sponsor_path(sponsorship.sponsor)
      para sponsorship.sponsor_additional_info
    end

    panel 'Orphans' do
      table_for Orphan.active.currently_unsponsored do
        column :id
        column 'Name' do |_orphan|
          link_to _orphan.name, admin_orphan_path(_orphan)
        end
        column :gender
        column :father_alive
        column :mother_alive
        column 'Establish sponsorship' do |_orphan|
          link_to 'Sponsor this orphan',
                  admin_sponsor_sponsorships_path(sponsor_id: sponsorship.sponsor_id,
                                                orphan_id: _orphan.id),
                  method: :post
        end
      end
    end
  end

  member_action :inactivate, method: :put do
    @sponsorship = Sponsorship.find(params[:id])
    @sponsor = Sponsor.find(params[:sponsor_id])
    @sponsorship.inactivate
    flash[:success] = 'Sponsorship link was successfully terminated'
    redirect_to admin_sponsor_path(@sponsor)
  end

  controller do
    def create
      @orphan = Orphan.find(params[:orphan_id])
      @sponsor = Sponsor.find(params[:sponsor_id])
      Sponsorship.create!(sponsor: @sponsor, orphan: @orphan)
      flash[:success] = 'Sponsorship link was successfully created'
      redirect_to admin_sponsor_path(@sponsor)
    end
  end

  permit_params :orphan_id
end
