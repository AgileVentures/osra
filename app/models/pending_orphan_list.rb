class PendingOrphanList < ActiveRecord::Base
  has_attached_file :spreadsheet

  validates_attachment :spreadsheet, presence: true,
                       file_name: { matches: [/xls\Z/, /xlsx\Z/] }

  has_many :pending_orphans

  def full_name
    [name, father_name].join(' ')
  end
end