Rails.application.routes.draw do
  # Other routes definitions...

  # This is the new route for creating requests with the specified endpoint
  post '/api/requests', to: 'requests#create'

  # Keep the custom collection route for 'send_request' under the 'requests' resource
  resources :requests, only: [] do
    collection do
      post 'send', to: 'requests#send_request'
    end
  end

  get '/api/users/validate_token/:token', to: 'users#validate_token', as: 'validate_user_token'

  # More route definitions...
end
