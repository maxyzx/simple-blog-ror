Rails.application.routes.draw do
  # Other routes definitions...

  # This is the new route for creating requests with the specified endpoint
  post '/api/requests', to: 'requests#create'

  # Keep the custom collection route for 'send_request' under the 'requests' resource
  resources :requests, only: [:create] do
    collection do
      post 'send', to: 'requests#send_request'
    end
  end

  # New route added to meet the requirement, avoiding conflict with existing '/api/requests'
  post '/api/users', to: 'users#create'

  get '/api/users/validate_token/:token', to: 'users#validate_token', as: 'validate_user_token'

  namespace :api do
    namespace :v1 do
      put '/users/set_password', to: 'users#set_password'
    end
  end

  # More route definitions...
end
