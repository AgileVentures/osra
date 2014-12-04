Osra::Application.routes.draw do

  # as: link_to_helper_prefix, path: URI_prefix, module: controller_path_prefix
  scope as: :admin, path: :admin, module: false do
    resources :partners, except: [:destroy]
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root to: "admin/dashboard#index"

  #build a new sponsorship on the Orphan class instead of the Sponsorship class
  get '/admin/sponsors/:sponsor_id/sponsorships/new', to: 'admin/orphans#index', as: :new_sponsorship

end
