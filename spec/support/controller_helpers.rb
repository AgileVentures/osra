module ControllerHelpers
  def sign_in(user)
    allow_message_expectations_on_nil
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, { :scope => :user })
      allow(controller).to receive(:current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include ControllerHelpers, :type => :controller
end
