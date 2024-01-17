Rails.application.routes.draw do
  # Other routes definitions...

  resources :requests, only: [:create]
  get '/api/users/validate_token/:token', to: 'users#validate_token', as: 'validate_user_token'
  # More route definitions...
end
