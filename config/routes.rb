Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "root#index"

  get "search/index"
  post "search/results"

  get 'markdown/index'
  post 'markdown/update'

  get 'validate/index'
  post 'validate/update'
  get 'validate/update'
end
