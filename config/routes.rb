Rails.application.routes.draw do
  resources :photos, only: [:show]

  root "photos#index"
end
