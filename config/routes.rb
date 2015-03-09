Rails.application.routes.draw do
  resources :photos, only: [:show]

  root "photos#index"

  get   "/auth/:provider/callback", to: "sessions#create"
  match "/logout",                  to: "sessions#destroy", as: :logout,  via: [:get, :post]

  mount Sidekiq::Web => "/sidekiq"
end
