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
      table_for Orphan.active.currently_unsponsored.sort_by_param(params), sortable: true do

        column :osra_num, sortable: :osra_num
        column 'Name', sortable: :name do |_orphan|
        link_to _orphan.name, admin_orphan_path(_orphan)
        end
        column :father_name, sortable: :father_name
        column :gender, sortable: :gender
        column :date_of_birth, sortable: :date_of_birth
        column :original_province, sortable: 'addresses.province_id' do |_orphan|
          _orphan.original_address.province.name
        end
        column :partner, sortable: 'partners.name' do |_orphan|
          _orphan.partner.name
        end
        column :father_is_martyr, sortable: :father_is_martyr
        column :mother_alive, sortable: :mother_alive
        column :priority
        column :orphan_sponsorship_status, sortable: 'orphan_sponsorship_statuses.name'
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
