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
  permit_params :name, :father_name, :father_is_martyr, :father_date_of_death, 
                :mother_name, :mother_alive, :date_of_birth, :gender,
                :contact_number, :sponsored_by_another_org, 
                :minor_siblings_count, original_address_attributes: [ :city,
                :province_id, :neighborhood, :street, :details], 
                current_address_attributes: [ :city,
                :province_id, :neighborhood, :street, :details]


  form do |f|
    f.inputs "Orphan" do
      f.input :name
      f.input :father_name
      f.input :father_is_martyr
      f.input :father_date_of_death
      f.input :mother_name
      f.input :mother_alive
      f.input :date_of_birth
      f.input :gender
      f.input :contact_number
      f.input :sponsored_by_another_org
      f.input :minor_siblings_count
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
