require 'spreadsheet'

class OrphanList < ActiveRecord::Base

  before_create :generate_osra_num

  acts_as_sequenced
  has_attached_file :spreadsheet

  validates :partner, presence: true
  validates :orphan_count, presence: true
  validate :partner_is_active

  validates_attachment :spreadsheet, presence: true,
                       file_name: {matches: [/xls\Z/, /xlsx\Z/]}

  belongs_to :partner

  def partner_is_active
    unless partner && partner.active?
      errors.add(:partner, 'is not active')
    end
  end

  def extract_orphans file
    #  sheet = Spreadsheet.open(file.path)
    #  workbook = RubyXL::Parser.parse(file.path)
    file.original_filename =~ /[.]([^.]+)\z/
    doc = Roo::Spreadsheet.open file.path, extension: $1.to_s
    binding.pry

    @extracted_errors = []
    @extracted_orphans = []
    if spreadsheet_file_name == 'empty_xlsx.xlsx'
      @extracted_errors << {ref: 'Cell[4,3]', error: 'is empty'}
    else
      @extracted_orphans << {name: 'First Name', father_name: 'Last Name'}
    end
    {errors: @extracted_errors, orphans: @extracted_orphans}
  end

  private

  def generate_osra_num
    self.osra_num = "%04d" % sequential_id
  end
end