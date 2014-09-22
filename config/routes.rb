Osra::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root to: "admin/dashboard#index"
  post '/admin/sponsors/:sponsor_id/sponsorships/:orphan_id',
       to: 'admin/sponsorships#create',
       as: :admin_sponsorship_create

  delete '/admin/sponsors/:sponsor_id/sponsorships/:orphan_id',
         to: 'admin/sponsorships#destroy',
         as: :admin_sponsorship_destroy
end
