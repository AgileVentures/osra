Osra::Application.routes.draw do

  # as: link_to_helper_prefix, path: URI_prefix, module: controller namespace
  scope as: :hq, path: :hq, module: :hq do
    resources :partners, except: [:create, :new, :show, :edit, :update, :destroy]
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root to: "admin/dashboard#index"

  #build a new sponsorship on the Orphan class instead of the Sponsorship class
  get '/admin/sponsors/:sponsor_id/sponsorships/new', to: 'admin/orphans#index', as: :new_sponsorship

end
