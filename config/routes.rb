
Rails.application.routes.draw do
  # Other routes definitions...

  resources :requests, only: [:create]
  # More route definitions...
end
