Rails.application.routes.draw do
  root 'static_pages#home'

  # Static Pages routes
  get 'help',    to: 'static_pages#help'
  get 'about',   to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'

  # User routes
  get  'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  # Custom route for pagy
  get 'users/page/:page', to: 'users#index', as: :pagy

  resources :users, except: %i[new create]

  # Sessions login/logout
  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Account activations
  resources :account_activations, only: :edit

  # Password resets
  resources :password_resets, except: %i[index show destroy]
end
