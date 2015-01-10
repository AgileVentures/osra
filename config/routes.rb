Osra::Application.routes.draw do

  namespace :hq do
    resources :partners, except: [:destroy] do
      resources :orphan_lists, only: [:index]
    end
    resources :users, except: [:destroy]
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root to: "admin/dashboard#index"

  #build a new sponsorship on the Orphan class instead of the Sponsorship class
  get '/admin/sponsors/:sponsor_id/sponsorships/new', to: 'admin/orphans#index', as: :new_sponsorship

end
