Osra::Application.routes.draw do

  scope :admin do #views moved into rails from activeadmin
    resources :partners, :except => [:new, :create, :edit, :update, :destroy]
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root to: "admin/dashboard#index"

  #build a new sponsorship on the Orphan class instead of the Sponsorship class
  get '/admin/sponsors/:sponsor_id/sponsorships/new', to: 'admin/orphans#index', as: :new_sponsorship

end
