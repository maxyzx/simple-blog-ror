Rails.application.routes.draw do
  namespace :v1 do
    resources :articles, only: [] do
      resources :comments, only: [:create]
    end
  end

  resources :articles do
    resources :comments, only: [:destroy]
  end

  # Other routes
  post '/users/:user_id/agree_to_policies', to: 'users#agree_to_policies', as: 'agree_to_policies'
  post '/register', to: 'users#create'
  post '/create_request', to: 'application#create_request'
  post '/verify_email_and_set_password', to: 'users#verify_email_and_set_password'
end
