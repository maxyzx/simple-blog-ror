Rails.application.routes.draw do
  # Other routes definitions...

  resources :requests, only: [:create] do
    collection do
      post 'send', to: 'requests#send_request'
    end
  end

  get '/api/users/validate_token/:token', to: 'users#validate_token', as: 'validate_user_token'

  # More route definitions...
end
