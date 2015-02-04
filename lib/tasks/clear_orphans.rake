namespace :db do
  desc 'Clear all orphan-related data from the db'
  task :clear_orphans => :environment do
    Orphan.destroy_all
    OrphanList.destroy_all
    PendingOrphan.destroy_all
    PendingOrphanList.destroy_all
    Sponsorship.delete_all # skip callbacks on already destroyed orphan records

    Sponsor.update_all(:request_fulfilled => false)

    puts '=> Done.'
  end
end
