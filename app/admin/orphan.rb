ActiveAdmin.register Orphan do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end
  permit_params :name, :father_name, :father_is_martyr, :father_occupation, 
                :father_place_of_death, :father_cause_of_death, 
                :father_date_of_death, :mother_name, :mother_alive, 
                :date_of_birth, :gender, :health_status, :schooling_status,
                :goes_to_school, :guardian_name, :guardian_relationship, 
                :guardian_id, :contact_number, :alt_contact_number, 
                :sponsored_by_another_org, :another_org_sponsorship_details, 
                :minor_siblings_count, :sponsored_minor_siblings_count, 
                :comments,
                original_address_attributes: [ :city,
                :province_id, :neighborhood, :street, :details], 
                current_address_attributes: [ :city,
                :province_id, :neighborhood, :street, :details]


  form do |f|
    f.inputs "Orphan" do
      f.input :name
      f.input :father_name
      f.input :father_is_martyr
      f.input :father_occupation
      f.input :father_place_of_death
      f.input :father_cause_of_death
      f.input :father_date_of_death
      f.input :mother_name
      f.input :mother_alive
      f.input :date_of_birth
      f.input :gender
      f.input :health_status
      f.input :schooling_status
      f.input :goes_to_school
      f.input :guardian_name
      f.input :guardian_relationship
      f.input :guardian_id
      f.input :contact_number
      f.input :alt_contact_number
      f.input :sponsored_by_another_org
      f.input :another_org_sponsorship_details
      f.input :minor_siblings_count
      f.input :sponsored_minor_siblings_count
      f.input :comments
    end
   

    f.inputs "Current Adress" do
      f.semantic_fields_for :current_address do |r| 
        r.inputs :city
        r.inputs :province
        r.inputs :neighborhood
        r.inputs :street
        r.inputs :details
      end 
    end
    f.inputs "Original Adress" do
      f.semantic_fields_for :original_address do |r| 
        r.inputs :city
        r.inputs :province
        r.inputs :neighborhood
        r.inputs :street
        r.inputs :details
      end 
    end
    f.actions
  end

  controller do 
    def new
      @orphan = Orphan.new
      @orphan.build_original_address
      @orphan.build_current_address
    end
  end

end
