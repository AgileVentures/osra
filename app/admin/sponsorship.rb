ActiveAdmin.register Sponsorship do
  actions :all, except: [:index, :show, :edit, :update]
  belongs_to :sponsor

  form do |f|
    panel 'Sponsor' do
      h3 sponsorship.sponsor_name
      para sponsorship.sponsor_additional_info
    end

    panel 'Orphans' do
      table_for Orphan.all do |orphan|
        column :name
        column :gender
        column :date_of_birth
        column '' do
          link_to 'Sponsor this orphan', admin_sponsor_sponsorships_path(sponsorship.sponsor), orphan_id: orphan.id, method: :post
        end
      end
    end
  end

  permit_params :orphan_id
end
