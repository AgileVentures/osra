require 'rails_helper'

describe PendingOrphan, type: :model do
  let(:pending_orphan) {PendingOrphan.new}
  let(:attributes) { {id: nil, pending_orphan_list_id: nil, name: "الطفل", father_name: "الأب", father_is_martyr: true, father_occupation: "مهنة الأب", father_place_of_death: "مكان الوفاة", father_cause_of_death: "سبب الوفاة", father_date_of_death: "2011-03-15", mother_name: "الأم", mother_alive: true, date_of_birth: "2009-03-15", gender: "Male", health_status: "معافى", schooling_status: "الصف الرابع", goes_to_school: true, guardian_name: "الوصي", guardian_relationship: 0, guardian_id_num: 448273, original_address_province: 12, original_address_city: "مدينة حلب", original_address_neighborhood: "الحي", original_address_street: "الشارع", original_address_details: nil, current_address_province: 13, current_address_city: "مدينة حمص", current_address_neighborhood: "حي", current_address_street: nil, current_address_details: "تفصيل", contact_number: 998716.0, alt_contact_number: "رقم آخر", sponsored_by_another_org: false, another_org_sponsorship_details: nil, minor_siblings_count: 7, sponsored_minor_siblings_count: 0, comments: "ملاحظات"} }

  specify '#create_orphan' do
    orphan = pending_orphan.orphan
    expect(orphan.class.name).to eq 'Orphan'
  end

  describe '#to_orphan' do
    it 'returns an orphan' do
      pending_orphan.attributes = attributes
      orphan = pending_orphan.to_orphan
      expect(orphan.class.name).to eq 'Orphan'
      expect(orphan.is_a?(Orphan)).to be true
    end
  end

  specify '#address_prefix' do
    expect(pending_orphan.address_prefix('address')).to eq 'address_'
  end

  specify '#pending_attrs_to_orphan' do
    remove_hash = {:pending => 'val', :address => 'val', :id => 'val'}
    expect(pending_orphan).to receive(:attributes).and_return(remove_hash)
    expect(pending_orphan.pending_attrs_to_orphan).to eq Hash.new
  end

  specify '#extract_and_create_address' do
    expect(pending_orphan).to receive(:attributes).and_return(attributes)
    expect(Province).to receive(:find_by_code).and_return(create :province)
    pending_orphan.extract_and_create_address('original_address')
    expect(pending_orphan.instance_variable_get(:@orphan).original_address).to be_valid
  end

  specify '#fields_starting_with' do
    start_hash = {key1: 'val', key2: 'val', other_key: 'val'}
    end_hash = {key1: 'val', key2: 'val'}
    expect(pending_orphan.fields_starting_with(start_hash, 'key')).
      to eq end_hash
  end

  specify '#remove_prefix_from_keys' do
    start_hash = {original_address_street: 'val', 
      original_address_city: 'val'}
    end_hash = {"street" => 'val', "city" => 'val'}
    expect(pending_orphan.remove_prefix_from_keys(start_hash,
      'original_address_')).to eq end_hash
  end
end
