class PendingOrphan < ActiveRecord::Base
  belongs_to :pending_orphan_list
end
