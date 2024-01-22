Rails.application.routes.draw do
  # Other routes...

  # This route is for listing all articles, as per the requirement
  get '/articles', to: 'articles#index'

  # More routes...
end
