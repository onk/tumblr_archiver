Rails.application.routes.draw do
  resources :photos, only: [:show, :update] do
    collection do
      match :search, via: [:get, :post]
      get :recent
    end
  end
  resources :actors, only: [:show], param: :name

  root "photos#index"

  get   "/auth/:provider/callback", to: "sessions#create"
  match "/logout",                  to: "sessions#destroy", as: :logout, via: [:get, :post]

  mount Sidekiq::Web => "/sidekiq"

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
