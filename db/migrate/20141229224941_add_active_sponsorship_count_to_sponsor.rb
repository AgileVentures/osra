class AddActiveSponsorshipCountToSponsor < ActiveRecord::Migration
  def up
    add_column :sponsors, :active_sponsorship_count, :integer, default: 0

    Sponsor.all.each do |sponsor|
      number_of_active_sponsorships = sponsor.sponsorships.all_active.count
      sponsor.update_attribute(:active_sponsorship_count, number_of_active_sponsorships)
    end
  end

  def down
    remove_column :sponsors, :active_sponsorship_count
  end

end
