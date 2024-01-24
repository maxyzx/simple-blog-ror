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
  post '/register', to: 'users#create'
  post '/verify_email_and_set_password', to: 'users#verify_email_and_set_password'
end
