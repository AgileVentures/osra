Osra::Application.routes.draw do

  namespace :hq do
  get 'dashboard/index'
  end

  devise_for :admin_users, path: "hq", as: "hq", path_names: { sign_in: 'login', sign_out: 'logout' },
                           :controllers => { :sessions => "hq/devise/sessions" }
  namespace :hq do
    root to: "dashboard#index"
    resources :dashboard, only: [:index]
    resources :partners, except: [:destroy] do
      resources :orphan_lists, only: [:index]
      resources :pending_orphan_lists do
        delete 'destroy', on: :member
        get 'upload', on: :collection
        post 'validate', on: :collection
        post 'import', on: :collection
      end
    end
    resources :users, except: [:destroy]
    resources :sponsors, except: [:destroy] do
      resources :sponsorships, only: :destroy , shallow: true do
        put "inactivate", on: :member
      end
    end
    resources :orphans, except: [:new, :create, :destroy]
    resources :admin_users, except: [:show]
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root to: "admin/dashboard#index"

  #build a new sponsorship on the Orphan class instead of the Sponsorship class
  get '/admin/sponsors/:sponsor_id/sponsorships/new', to: 'admin/orphans#index', as: :new_sponsorship

end
