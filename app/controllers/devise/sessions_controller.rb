class Hq::Devise::SessionsController < Devise::SessionsController
  layout 'application'

private

  def after_sign_out_path_for(resource_or_scope)
    new_hq_admin_user_session_path
  end

  def after_sign_in_path_for(resource)
    hq_root_path
  end
end