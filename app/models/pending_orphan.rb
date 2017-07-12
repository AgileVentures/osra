class PendingOrphan < ActiveRecord::Base
  belongs_to :pending_orphan_list
  after_initialize :create_orphan
  attr_accessor :orphan

  def father_name
    "#{father_given_name} #{family_name}"
  end

  def create_orphan
    @orphan = Orphan.new
  end

  def to_orphan
    extract_and_create_addresses
    pending_attrs_to_orphan
    orphan
  end

  def address_prefix(address)
    "#{address}_"
  end

  def pending_attrs_to_orphan
    orphan.attributes = attributes.reject do |key, _|
      key['address'] || key['pending'] || key['id']
    end
  end

  def extract_and_create_addresses
    ['current_address', 'original_address'].each do |address|
      extract_and_create_address address
    end
  end

  def extract_and_create_address(address_type)
    prefix = address_prefix address_type
    addr_fields = fields_starting_with(self.attributes, prefix)
    addr_params = remove_prefix_from_keys(addr_fields, prefix)
    addr_params['province'] = Province.find_by_code(addr_params['province'])
    orphan.send "#{address_type}=", Address.new(addr_params)
  end

  def fields_starting_with(dict, prefix)
    dict.select { |key, _| String(key).starts_with? prefix }
  end

  def remove_prefix_from_keys(dict, prefix)
    dict.map{ |key, val| [(String(key).gsub prefix, ''), val] }.to_h
  end
end
