require 'rails_helper'

RSpec.describe AdminUser, :type => :model do
  it 'should have a valid factory' do
    expect(build_stubbed :admin_user).to be_valid
  end
end
