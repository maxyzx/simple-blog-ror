Rails.application.routes.draw do
  # Other routes...

  namespace :v1 do
    resources :articles, only: [:show]
  end

  # More routes...
end
