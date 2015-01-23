Osra::Application.routes.draw do

  namespace :hq do
    # :shallow option shortens URLs when possible
    resources :partners, except: [:destroy], shallow: true do
      resources :orphan_lists, only: [:index]
      resources :pending_orphan_lists do # , path_names: { new: 'upload', create: 'validate' }
        # delete 'destroy', on: :member - redundant, get this with `resources`
        # DRY collection routes declaration
        collection do
          get 'upload' # new?
          post 'validate' # create?
          post 'import'
        end
      end
    end
    resources :users, except: [:destroy]
    resources :sponsors, except: [:destroy]
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root to: "admin/dashboard#index"

  #build a new sponsorship on the Orphan class instead of the Sponsorship class
  # - replace ", to:" with shorthand "=>"
  # - constrain `:sponsor_id` to a numeric value (ideally should provide second
  # route to handle non-numeric sponsor_id)
  get '/admin/sponsors/:sponsor_id/sponsorships/new' => 'admin/orphans#index',
    as: :new_sponsorship,
    constraints: { :sponsor_id => /\d+/ }

  # cool: allow sponsorships only to sponsors with id < 50
  # get '/admin/sponsors/:sponsor_id/sponsorships/new' => 'admin/orphans#index',
  #   as: :new_sponsorship,
  #   constraints: proc { |req| req.params[:sponsor_id].to_i < 50 }

  # just for fun - the value of `to:` is a Rack endpoint
  # meaning that it can easily map to a Rack app - e.g. one built in Sinatra
  get '/hello', to: proc { |env| [200, {}, ['Hello world!']] }

end
