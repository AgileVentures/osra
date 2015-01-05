require_relative 'excel_upload'

class OrphanImporter

#
# This is the class which handles the importing of orphan rows from the spreadsheet. 
# The rows are read in from the spreadsheet using the roo gem, and the information in each spreadsheet cell
# is read using the roo gem #cell and #celltype methods. 
# The mapping from spreadsheet columns to orphan attributes is driven off the text in the spreadsheet header rows,
# matching using the @@headers data structure. This enables the column id to be set for each attribute on a 
# per-spreadsheet basis. (It's conceivable that different spreadsheets may have the fields in different columns).
# To make the rows ready for import into the database this OrphanImporter class then does 4 things:
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
# Steps 1 to 3 above are governed through the @mapper instance variable below (once the spreadsheet column ids 
# are added to it).
# If any errors are identified then details of these are added to the @import_errors array. 
# The output from the extract_orphans method below is an array of 3 entries:
#   - a boolean specifying if the spreadsheet was clean or not (ie no validation errors found)
#   - an array of the (pending) orphan records
#   - an array of the import errors identified
# It's a requirement that the spreadsheet support both Arabic and English headers and data values, the latter
# to make test spreadsheets more easily understood by the development team. 
#  
  @@yn_to_bool = { 'y' => true, 'Y' => true, 'n' => false, 'N' => false }
  @@male_arabic_yn_to_bool = { 'موجود' => true, 'متوفى' => false, 'y' => true, 'Y' => true, 'n' => false, 'N' => false }
  @@female_arabic_yn_to_bool = { 'موجودة' => true, 'متوفاة' => false, 'y' => true, 'Y' => true, 'n' => false, 'N' => false }
  @@gender = { 'ذكر' => 'Male', 'أنثى' => 'Female', 'Male' => 'Male', 'Female' => 'Female'}
  @@province_to_code = { 'دمشق وريف دمشق' => 11, 'Damascus & Rif Dimashq' => 11, 'حلب' => 12, 'Aleppo' => 12, 
    'حمص' => 13, 'Homs' => 13, 'حماة' => 14, 'Hama' => 14, 'اللاذقية' => 15, 'Latakia' => 15,
    'دير الزور' => 16, 'Deir Al-Zor' => 16, 'درعا' => 17, 'Daraa' => 17, 'إدلب' => 18, 'Idlib' => 18, 
    'الرقة' => 19, 'Ar Raqqah' => 19, 'الحسكة' => 20, 'Al Hasakah' => 20, 'طرطوس' => 21, 'Tartous' => 21,
    'السويداء' => 22, 'Al-Suwayada' => 22, 'القنيطرة' => 23, 'Al-Quneitera' => 23, 
    'خارج سوريا' => 29, 'Outside Syria' => 29 } 

  @@first_row = 4;  # first row of the spreadsheet which contains data
  # in the array below the English headers are the orphan attributes, with underscores replaced by spaces
  # except for the first which is set to "orphan name" rather than "name" to avoid the clash with guardian name 
  @@header_titles = 
  [{ desc1: 'اسم اليتيم الأول', disregard_case: false, orphan_attr: :name },
   { desc1: 'orphan name', disregard_case: true, orphan_attr: :name }, 
   { desc1: 'اسم الأب', disregard_case: false, orphan_attr: :father_given_name },
   { desc1: 'father given name', disregard_case: true, orphan_attr: :father_given_name },
   { desc1: 'اسم العائلة', disregard_case: false, orphan_attr: :family_name },
   { desc1: 'family name', disregard_case: true, orphan_attr: :family_name },
   { desc1: 'ابن شهيد؟', disregard_case: false, orphan_attr: :father_is_martyr },
   { desc1: 'father is martyr', disregard_case: true, orphan_attr: :father_is_martyr },
   { desc1: 'المهنة', disregard_case: false, orphan_attr: :father_occupation },
   { desc1: 'father occupation', disregard_case: true, orphan_attr: :father_occupation },
   { desc1: 'الأب متوفي؟', disregard_case: false, orphan_attr: :father_alive },
   { desc1: 'father alive', disregard_case: true, orphan_attr: :father_alive },
   { desc1: 'مكان الوفاة', disregard_case: false, orphan_attr: :father_place_of_death },
   { desc1: 'father place of death', disregard_case: true, orphan_attr: :father_place_of_death },
   { desc1: 'سبب الوفاة', disregard_case: false, orphan_attr: :father_cause_of_death },
   { desc1: 'father cause of death', disregard_case: true, orphan_attr: :father_cause_of_death },
   { desc1: 'تاريخ الوفاة (اجباري في حال الاب متوفي)', disregard_case: false, orphan_attr: :father_date_of_death },
   { desc1: 'father date of death', disregard_case: true, orphan_attr: :father_date_of_death },
   { desc1: 'اسم  الأم', disregard_case: false, orphan_attr: :mother_name },
   { desc1: 'mother name', disregard_case: true, orphan_attr: :mother_name },
   { desc1: 'موجودة/متوفاة', disregard_case: false, orphan_attr: :mother_alive },
   { desc1: 'mother alive', disregard_case: true, orphan_attr: :mother_alive },
   { desc1: 'مواليد اليتيم', disregard_case: false, orphan_attr: :date_of_birth },
   { desc1: 'date of birth', disregard_case: true, orphan_attr: :date_of_birth },
   { desc1: 'الجنس', disregard_case: false, orphan_attr: :gender },
   { desc1: 'gender', disregard_case: true, orphan_attr: :gender },
   { desc1: 'الحالة الصحية', disregard_case: false, orphan_attr: :health_status },
   { desc1: 'health status', disregard_case: true, orphan_attr: :health_status },
   { desc1: 'الحالة الدراسية اي صف ؟', disregard_case: false, orphan_attr: :schooling_status },
   { desc1: 'schooling status', disregard_case: true, orphan_attr: :schooling_status },
   { desc1: 'يذهب للمدرسة ؟', disregard_case: false, orphan_attr: :goes_to_school },
   { desc1: 'goes to school', disregard_case: true, orphan_attr: :goes_to_school },

   { desc1: 'الاسم', desc2: 'معلومات الوصي / ولي الأمر', disregard_case: false, orphan_attr: :guardian_name },
   { desc1: 'name', desc2: 'guardian', disregard_case: true, orphan_attr: :guardian_name },
   { desc1: 'صلة القرابة', desc2: 'معلومات الوصي / ولي الأمر', disregard_case: false, orphan_attr: :guardian_relationship },
   { desc1: 'relationship', desc2: 'guardian', disregard_case: true, orphan_attr: :guardian_relationship },
   { desc1: 'رقم الهوية', desc2: 'معلومات الوصي / ولي الأمر', disregard_case: false, orphan_attr: :guardian_id_num },
   { desc1: 'id num', desc2: 'guardian', disregard_case: true, orphan_attr: :guardian_id_num },

   { desc1: 'المحافظة', desc2: 'العنوان الاصلي', disregard_case: false, orphan_attr: :original_address_province },
   { desc1: 'province', desc2: 'original address', disregard_case: true, orphan_attr: :original_address_province },
   { desc1: 'المدينة', desc2: 'العنوان الاصلي', disregard_case: false, orphan_attr: :original_address_city },
   { desc1: 'city', desc2: 'original address', disregard_case: true, orphan_attr: :original_address_city },
   { desc1: 'الحي', desc2: 'العنوان الاصلي', disregard_case: false, orphan_attr: :original_address_neighborhood },
   { desc1: 'neighborhood', desc2: 'original address', disregard_case: true, orphan_attr: :original_address_neighborhood },
   { desc1: 'الشارع', desc2: 'العنوان الاصلي', disregard_case: false, orphan_attr: :original_address_street },
   { desc1: 'street', desc2: 'original address', disregard_case: true, orphan_attr: :original_address_street },
   { desc1: 'التفصيل', desc2: 'العنوان الاصلي', disregard_case: false, orphan_attr: :original_address_details },
   { desc1: 'details', desc2: 'original address', disregard_case: true, orphan_attr: :original_address_details },

   { desc1: 'المحافظة', desc2: 'العنوان الحالي', disregard_case: false, orphan_attr: :current_address_province },
   { desc1: 'province', desc2: 'current address', disregard_case: true, orphan_attr: :current_address_province },
   { desc1: 'المدينة', desc2: 'العنوان الحالي', disregard_case: false, orphan_attr: :current_address_city },
   { desc1: 'city', desc2: 'current address', disregard_case: true, orphan_attr: :current_address_city },
   { desc1: 'الحي', desc2: 'العنوان الحالي', disregard_case: false, orphan_attr: :current_address_neighborhood },
   { desc1: 'neighborhood', desc2: 'current address', disregard_case: true, orphan_attr: :current_address_neighborhood },
   { desc1: 'الشارع', desc2: 'العنوان الحالي', disregard_case: false, orphan_attr: :current_address_street },
   { desc1: 'street', desc2: 'current address', disregard_case: true, orphan_attr: :current_address_street },
   { desc1: 'التفصيل', desc2: 'العنوان الحالي', disregard_case: false, orphan_attr: :current_address_details },
   { desc1: 'details', desc2: 'current address', disregard_case: true, orphan_attr: :current_address_details },
   
   { desc1: 'رقم/ حساب اتصال', disregard_case: false, orphan_attr: :contact_number }, 
   { desc1: 'contact number', disregard_case: true, orphan_attr: :contact_number },
   { desc1: 'رقم بديل', disregard_case: false, orphan_attr: :alt_contact_number },
   { desc1: 'alt contact number', disregard_case: true, orphan_attr: :alt_contact_number },
   { desc1: 'مكفول من جهة أخرى؟', disregard_case: false, orphan_attr: :sponsored_by_another_org },
   { desc1: 'sponsored by another org', disregard_case: true, orphan_attr: :sponsored_by_another_org },
   { desc1: 'الجهة الأخرى الكفيلة- تاريخ الكفالة وقيمتها', disregard_case: false, orphan_attr: :another_org_sponsorship_details },
   { desc1: 'another org sponsorship details', disregard_case: true, orphan_attr: :another_org_sponsorship_details },
   { desc1: 'عدد الاخوة تحت 18 سنة', disregard_case: false, orphan_attr: :minor_siblings_count },
   { desc1: 'minor siblings count', disregard_case: true, orphan_attr: :minor_siblings_count },
   { desc1: 'عدد الأخوة المكفولين', disregard_case: false, orphan_attr: :sponsored_minor_siblings_count },
   { desc1: 'sponsored minor siblings count', disregard_case: true, orphan_attr: :sponsored_minor_siblings_count },
   { desc1: 'ملاحظات', disregard_case: false, orphan_attr: :comments },
   { desc1: 'comments', disregard_case: true, orphan_attr: :comments }]


  def initialize(file, partner)
    @mapper = 
    [{ orphan_attribute: :name,                          expected_type: :string,  converter: nil }, 
     { orphan_attribute: :father_given_name,             expected_type: :string,  converter: nil }, 
     { orphan_attribute: :family_name,                   expected_type: :string,  converter: nil }, 
     { orphan_attribute: :father_is_martyr,              expected_type: :string,  converter: @@yn_to_bool }, 
     { orphan_attribute: :father_occupation,             expected_type: :string,  converter: nil },
     { orphan_attribute: :father_alive,                  expected_type: :string,  converter: @@male_arabic_yn_to_bool }, 
     { orphan_attribute: :father_place_of_death,         expected_type: :string,  converter: nil }, 
     { orphan_attribute: :father_cause_of_death,         expected_type: :string,  converter: nil }, 
     { orphan_attribute: :father_date_of_death,          expected_type: :date,    converter: nil }, 
     { orphan_attribute: :mother_name,                   expected_type: :string,  converter: nil }, 
     { orphan_attribute: :mother_alive,                  expected_type: :string,  converter: @@female_arabic_yn_to_bool }, 
     { orphan_attribute: :date_of_birth,                 expected_type: :date,    converter: nil }, 
     { orphan_attribute: :gender,                        expected_type: :string,  converter: @@gender }, 
     { orphan_attribute: :health_status,                 expected_type: :string,  converter: nil }, 
     { orphan_attribute: :schooling_status,              expected_type: :string,  converter: nil }, 
     { orphan_attribute: :goes_to_school,                expected_type: :string,  converter: @@yn_to_bool }, 
     { orphan_attribute: :guardian_name,                 expected_type: :string,  converter: nil }, 
     { orphan_attribute: :guardian_relationship,         expected_type: :string,  converter: nil }, 
     { orphan_attribute: :guardian_id_num,               expected_type: :float,   converter: nil }, 
     { orphan_attribute: :original_address_province,     expected_type: :string,  converter: @@province_to_code }, 
     { orphan_attribute: :original_address_city,         expected_type: :string,  converter: nil }, 
     { orphan_attribute: :original_address_neighborhood, expected_type: :string,  converter: nil }, 
     { orphan_attribute: :original_address_street,       expected_type: :string,  converter: nil }, 
     { orphan_attribute: :original_address_details,      expected_type: :string,  converter: nil }, 
     { orphan_attribute: :current_address_province,      expected_type: :string,  converter: @@province_to_code }, 
     { orphan_attribute: :current_address_city,          expected_type: :string,  converter: nil }, 
     { orphan_attribute: :current_address_neighborhood,  expected_type: :string,  converter: nil }, 
     { orphan_attribute: :current_address_street,        expected_type: :string,  converter: nil }, 
     { orphan_attribute: :current_address_details,       expected_type: :string,  converter: nil }, 
     { orphan_attribute: :contact_number,                expected_type: :string,  converter: nil }, 
     { orphan_attribute: :alt_contact_number,            expected_type: :string,  converter: nil }, 
     { orphan_attribute: :sponsored_by_another_org,      expected_type: :string,  converter: @@yn_to_bool }, 
     { orphan_attribute: :another_org_sponsorship_details, expected_type: :string,converter: nil }, 
     { orphan_attribute: :minor_siblings_count,            expected_type: :float, converter: nil }, 
     { orphan_attribute: :sponsored_minor_siblings_count,  expected_type: :float, converter: nil }, 
     { orphan_attribute: :comments,                        expected_type: :string,converter: nil }]
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
      analyse_header_rows(spreadsheet)
      report_unmatched_columns
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

  def analyse_header_rows(doc)
  #
  # This method analyses the header rows, works out the column id for each orphan attribute, and
  # sets this in the @mapper structure. 
  # Note that:
  # 1. The titles of the columns are spread over the first 3 rows, and the key column title that we want
  # to match on could appear in any one of these 3 rows
  # 2. If there are merged cells, then the roo gem presents the data in the 'lowest' column. For example,
  # if cells R2 to T2 are merged, then the value will appear when you access cell R2.
  # 3. For fields associated with current address and original address we have to take a combination of
  # titles in rows 2 and 3.
  #
    column = 'A'
    merged_cell_values = Array.new(@@first_row-1){|i| nil}  # set values of merged cells all to nil initially
    while true do
      headers_read = []
      (@@first_row-1).downto(1) do |row| # read the header titles for that column, going up from the last header row
        title = doc.cell(row, column)
        headers_read << title 
      end
      break if headers_read.all?{|h| h.nil?} # we've reached the end of columns with text in any header row
      #
      # now we need to handle the merged cells - filling in for values which have appeared in previous columns
      # (overwriting any nil values with merged cell values) and setting up values for subsequent columns.
      #
      headers_read = headers_read.map.with_index { |h, i| h || merged_cell_values[i] } 
      merged_cell_values = headers_read
      #
      # now try to match the headers we've just read with the header titles we're expecting
      #
      headers_read.each_with_index do |header_row, i|
        next if header_row.nil?
        found_a_match = false
        @@header_titles.each_with_index do |header_title_entry|
          # try to match this spreadsheet header with this entry in the array of expected header titles
          # pass also the next header from the row above (if there's one) in case it needs to match with desc2
          # (if there isn't a next row and we go beyond the end of the array then ruby will just pass nil)
          if headers_match(header_title_entry, header_row, headers_read[i+1])
            @mapper.each{ |m| m[:spreadsheet_column] = column if m[:orphan_attribute] == header_title_entry[:orphan_attr] }
            found_a_match = true
            break
          end
        end
        break if found_a_match
      end
      column = column.next   # works ok for Z to AA, etc
    end
  end

  def headers_match(h, hdr_row1, hdr_row2)
    if strings_match(hdr_row1, h[:desc1], h[:disregard_case])
      if h[:desc2].nil?      
        return true
      else  # check if the next row above matches desc2 as well
        return strings_match(hdr_row2, h[:desc2], h[:disregard_case])
      end
    end   
    false 
  end

  def strings_match(s1, s2, disregard_case)
    return false if s1.nil? || s2.nil?
    disregard_case ? s1.strip.upcase == s2.strip.upcase : s1.strip == s2.strip
  end

  def report_unmatched_columns
    @mapper.each do |mapper_entry|
      if mapper_entry[:spreadsheet_column].nil?
        add_import_errors("invalid headers in spreadsheet", "no header found for #{mapper_entry[:orphan_attribute]}" +
          " (Field set to blank to allow further validation checks to proceed).")
      end
    end
  end

  def import_orphan(doc, row)
    #
    # this method handles the mapping of a single row in the spreadsheet to the set of orphan attributes
    # Note that the Roo gem doesn't always return the cell value (from doc.cell) as a String.
    # Sometimes it's returned as a Date or Float, depending upon what's in the cell.  
    # The code checks the type is as expected, and does any required conversion of the value.
    #
    fields = Hash.new
    @mapper.each do |mapper_entry|
      cell_val = doc.cell(row, mapper_entry[:spreadsheet_column])
      cell_type = doc.celltype(row, mapper_entry[:spreadsheet_column])
      if cell_val.nil?  # just set attribute to blank - orphan model validation will catch mandatory aspects
        fields[mapper_entry[:orphan_attribute]] = ""  
      else
        if cell_type == mapper_entry[:expected_type]  # then copy cell to attribute, doing any necessary conversion
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
      false # set so that the calling function knows that the block passed in caused an exception
    end
  end

  def upload_spreadsheet
    log_exceptions { ExcelUpload.upload(@file, @@first_row) }
  end

end

