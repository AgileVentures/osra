require_relative 'excel_upload'

class String 
#
# These are utility methods added to convert between the string held in a spreadsheet cell
# and the format required in the orphan record (eg to convert from Arabic)
# In general, these routines don't expect a blank to be passed, 
# and a nil being returned indicates that it didn't match what was expected (ie error)
#
# This extension of String should be changed to use a Ruby Refinement, once they're a bit more stable.
#

  def cell_to_date
    Date.parse(self) rescue nil
  end



end

class Float
  def cell_to_int
    self.to_s.to_i rescue nil
  end
end

class OrphanImporter
  class ImportConfigurationError < StandardError
  end
#
# This is the class which handles the importing of orphan rows from the spreadsheet. 
# The rows are read in from the spreadsheet using the roo gem, and the information in each spreadsheet cell
# is read using the roo gem #cell and #celltype methods. 
# To make the rows ready for import into the database this OrphanImporter class does 4 things:
#   1. It checks the celltype which roo returns to make sure that it aligns with the expected type for that cell.
#      If it doesn't align, then it converts it to a String, and this may result in the later validation failing.
#      Note that roo works out the type based on the type of data in the spreadsheet cell. For example, if the
#      data in the cell is a number, roo will pass the type as Float. 
#      See http://www.rubydoc.info/gems/roo/Roo/Excelx#celltype-instance_method
#   2. It converts the value in some fields using the hashes below (eg to convert Arabic to English). 
#      (This may result in an error - eg if the Arabic string is misspelt)
#   3. It maps that spreadsheet cell to the appropriate orphan attribute, based on the spreadsheet column
#   4. It validates the orphan attributes using the Rails orphan Model, and also checks that there aren't
#      duplicate entries in the rows read in from the spreadsheet.
# Steps 1 to 3 above are governed through the @@mapper class variable below.
# If any errors are identified then details of these are added to the @import_errors array. 
# The output from the extract_orphans method below is:
#   - a boolean specifying if the spreadsheet was clean or not (ie no validation errors found)
#   - an array of the orphan records
# The instance variable @import_errors is also set so that the view can display these
#  
  @@yn_to_bool = { 'y' => true, 'Y' => true, 'n' => false, 'N' => false }
  @@father_alive_to_bool = { 'موجود' => true, 'متوفى' => false }
  @@mother_alive_to_bool = { 'موجودة' => true, 'متوفاة' => false }
  @@gender = { 'ذكر' => 'Male', 'أنثى' => 'Female'}
  @@province_to_code = { 'دمشق و ريف دمشق' => 11, 'حلب' => 12, 'حمص' => 13, 'حماة' => 14, 'اللاذقية' => 15,
    'دير الزور' => 16, 'درعا' => 17, 'إدلب' => 18, 'الرقة' => 19, 'الحسكة' => 20, 'طرطوس' => 21,
    'السويداء' => 22, 'القنيطرة' => 23, 'خارج سوريا' => 29 }
  @@mapper = 
    [{ orphan_attribute: :name,                 spreadsheet_column: 'B',  expected_type: :string,  converter: nil }, 
     { orphan_attribute: :father_name,          spreadsheet_column: 'C',  expected_type: :string,  converter: nil }, 
     { orphan_attribute: :father_is_martyr,     spreadsheet_column: 'D',  expected_type: :string,  converter: @@yn_to_bool }, 
     { orphan_attribute: :father_occupation,    spreadsheet_column: 'E',  expected_type: :string,  converter: nil },
     { orphan_attribute: :father_alive,         spreadsheet_column: 'F',  expected_type: :string,  converter: @@father_alive_to_bool }, 
     { orphan_attribute: :father_place_of_death,spreadsheet_column: 'G',  expected_type: :string,  converter: nil }, 
     { orphan_attribute: :father_cause_of_death,spreadsheet_column: 'H',  expected_type: :string,  converter: nil }, 
     { orphan_attribute: :father_date_of_death, spreadsheet_column: 'I',  expected_type: :date,    converter: nil }, 
     { orphan_attribute: :mother_name,          spreadsheet_column: 'J',  expected_type: :string,  converter: nil }, 
     { orphan_attribute: :mother_alive,         spreadsheet_column: 'K',  expected_type: :string,  converter: @@mother_alive_to_bool }, 
     { orphan_attribute: :date_of_birth,        spreadsheet_column: 'L',  expected_type: :date,    converter: nil }, 
     { orphan_attribute: :gender,               spreadsheet_column: 'M',  expected_type: :string,  converter: @@gender }, 
     { orphan_attribute: :health_status,        spreadsheet_column: 'N',  expected_type: :string,  converter: nil }, 
     { orphan_attribute: :schooling_status,     spreadsheet_column: 'O',  expected_type: :string,  converter: nil }, 
     { orphan_attribute: :goes_to_school,       spreadsheet_column: 'P',  expected_type: :string,  converter: @@yn_to_bool }, 
     { orphan_attribute: :guardian_name,        spreadsheet_column: 'Q',  expected_type: :string,  converter: nil }, 
     { orphan_attribute: :guardian_relationship,spreadsheet_column: 'R',  expected_type: :string,  converter: nil }, 
     { orphan_attribute: :guardian_id_num,      spreadsheet_column: 'S',  expected_type: :float,   converter: nil }, 
     { orphan_attribute: :original_address_province,spreadsheet_column: 'T',  expected_type: :string,     converter: @@province_to_code }, 
     { orphan_attribute: :original_address_city,spreadsheet_column: 'U',      expected_type: :string,     converter: nil }, 
     { orphan_attribute: :original_address_neighborhood,spreadsheet_column: 'V',  expected_type: :string, converter: nil }, 
     { orphan_attribute: :original_address_street,spreadsheet_column: 'W',    expected_type: :string,     converter: nil }, 
     { orphan_attribute: :original_address_details,spreadsheet_column: 'X',   expected_type: :string,     converter: nil }, 
     { orphan_attribute: :current_address_province,spreadsheet_column: 'Y',   expected_type: :string,     converter: @@province_to_code }, 
     { orphan_attribute: :current_address_city, spreadsheet_column: 'Z',      expected_type: :string,     converter: nil }, 
     { orphan_attribute: :current_address_neighborhood,spreadsheet_column: 'AA',  expected_type: :string, converter: nil }, 
     { orphan_attribute: :current_address_street,spreadsheet_column: 'AB',    expected_type: :string,     converter: nil }, 
     { orphan_attribute: :current_address_details,spreadsheet_column: 'AC',   expected_type: :string,     converter: nil }, 
     { orphan_attribute: :contact_number,       spreadsheet_column: 'AD',     expected_type: :string,     converter: nil }, 
     { orphan_attribute: :alt_contact_number,   spreadsheet_column: 'AE',     expected_type: :string,     converter: nil }, 
     { orphan_attribute: :sponsored_by_another_org,spreadsheet_column: 'AF',  expected_type: :string,     converter: @@yn_to_bool }, 
     { orphan_attribute: :another_org_sponsorship_details,spreadsheet_column: 'AG', expected_type: :string, converter: nil }, 
     { orphan_attribute: :minor_siblings_count, spreadsheet_column: 'AH',     expected_type: :float,      converter: nil }, 
     { orphan_attribute: :sponsored_minor_siblings_count,spreadsheet_column: 'AI', expected_type: :float, converter: nil }, 
     { orphan_attribute: :comments,             spreadsheet_column: 'AM',     expected_type: :string,     converter: nil }]
  @@first_row = 4;  # first row of the spreadsheet which contains data


  def initialize(file, partner)
    # spreadsheet rows which are successfully validated are added to @pending_orphans while
    # no errors are encountered in the spreadsheet.
    # If any errors are encountered then the code stops adding entries to @pending_orphans
    @pending_orphans = []
    # Any validation problems etc are added to @import_errors
    @import_errors = []
    @file = file
    @partner = partner
    @duplicates_hash = Hash.new([])  # used for checking there are no duplicates in the spreadsheet being imported
  end

  def extract_orphans
    spreadsheet = upload_spreadsheet
    if spreadsheet
      orphan_list = @@first_row.upto(spreadsheet.last_row){ |row| import_orphan(spreadsheet, row) }
      check_for_duplicates
    end
    return [no_errors_found_in_spreadsheet?, @pending_orphans, @import_errors]
  end

private

  def add_import_errors(ref, error)
    @import_errors << { ref: ref, error: error }
  end

  def no_errors_found_in_spreadsheet?
    @import_errors.empty?
  end

  def import_orphan(doc, row)
    #
    # this method handles the mapping of a single row in the spreadsheet to the set of orphan attributes
    # Note that the Roo gem doesn't always return the cell value (from doc.cell) as a String.
    # Sometimes it's returned as a Date or Float, depending upon what's in the cell.  
    # The code checks the type is as expected, and does any required conversion of the value.
    #
    fields = Hash.new
    @@mapper.each do |mapper_entry|
      cell_val = doc.cell(row, mapper_entry[:spreadsheet_column])
      cell_type = doc.celltype(row, mapper_entry[:spreadsheet_column])
      if cell_val.nil?  # just set attribute to blank - orphan model validation will catch mandatory aspects
        fields[mapper_entry[:orphan_attribute]] = ""  
      else
        if cell_type == mapper_entry[:expected_type]
          if mapper_entry[:converter].nil?
            fields[mapper_entry[:orphan_attribute]] = cell_val
            # The Roo gem returns numbers as Float, which will result in failing the orphan validation
            # Hence convert these to integers. This processing will need to be changed to be more sophisticated
            # in the future if the spreadsheet contains a mixture of integers and true floats.
            if mapper_entry[:expected_type] == :float
              fields[mapper_entry[:orphan_attribute]] = cell_val.to_s.to_i rescue nil
              if fields[mapper_entry[:orphan_attribute]].nil?   # couldn't convert it to an int - floats not allowed
                log_validation_error("Invalid number", row, mapper_entry)
              end
            end
          else  # we need to map the data through the appropriate converter Hash
            fields[mapper_entry[:orphan_attribute]] = mapper_entry[:converter][cell_val]
            if fields[mapper_entry[:orphan_attribute]].nil?  # ie couldn't find cell_val in the converter hash
              log_validation_error("Unrecognised data", row, mapper_entry) 
            end
          end
        else  # cell isn't of the expected type - just force it to be a string and let orphan model validation generate the error
          # however see this issue: https://github.com/zdavatz/spreadsheet/issues/41.
          # This means that if there's a text cell in the spreadsheet and you put 123 into it, then you will get
          # a Float 123.0 passed to you, and if you call to_s on this you get "123.0", instead of "123"  
          # As I think it's less likely that someone will enter something like 123.0 rather than an integer,
          # let's just remove the ".0" if it's at the end  
          fields[mapper_entry[:orphan_attribute]] = cell_val.to_s
          fields[mapper_entry[:orphan_attribute]].sub!(/.0$/,"")
        end
      end
    end
    hash_key = fields.select{ |k, _| [:name, :father_name, :mother_name].include? k }
    @duplicates_hash[hash_key] += [row]
    check_orphan_validity(fields, row)
    add_to_pending_orphans_if_all_still_ok(fields)
  end

  def add_to_duplicates(fields, row)
    hash_key = fields.select{ |k, _| %w[name father_name mother_name].include? k }
    @duplicates_hash[hash_key] += [row]
  end

  def add_to_pending_orphans_if_all_still_ok(fields)
    @pending_orphans << PendingOrphan.new(fields) if no_errors_found_in_spreadsheet?
  end

  def check_for_duplicates
    @duplicates_hash.values.select { |v| v.size > 1 }.each do |v|
      add_import_errors "duplicate entries found on rows #{v.join(', ')}",
                        "Orphan's name, mother's name & father's name are the same."
    end
  end

  def log_validation_error(text,row,mapper_entry)
    message = text + " in column #{mapper_entry[:spreadsheet_column]} #{mapper_entry[:orphan_attribute]}." + 
      " (Field set to blank to allow further validation checks to proceed)."
    add_import_errors("invalid data in row #{row}", message)
  end

  def check_orphan_validity(fields, row)
    orphan = PendingOrphan.new(fields).to_orphan
    orphan.partner = @partner
    unless orphan.valid?
      add_import_errors "invalid orphan attributes for row #{row}",
        orphan.errors.full_messages.join('; ')
    end
  end

  def log_exceptions(row=nil,col_settings=nil)
    begin
      yield
    rescue => e
      message = e.to_s
      message << " Error at row #{row}" if row
      if col_settings
        message << " for column #{col_settings.column}--#{col_settings.field}"
      end
      add_import_errors(e.class.name.split('::').last, message)
      false
    end
  end

  def upload_spreadsheet
    log_exceptions { ExcelUpload.upload(@file, settings.first_row) }
  end

end

