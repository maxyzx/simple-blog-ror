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
end
