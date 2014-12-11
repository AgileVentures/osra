require 'rails_helper'

RSpec.describe AdminUser, :type => :model do
  let :admin_user do
    AdminUser.create(email: 'example@server.com',
                 password: 'password',
                 password_confirmation: 'password')
  end
  context 'methods' do
    it 'should not return a memory pointer as its instance.to_s' do
      expect(admin_user.to_s=~ /#<\w+:0x([a-f]|[A-F]|[0-9])+>/).to be_nil
    end
  end
end
