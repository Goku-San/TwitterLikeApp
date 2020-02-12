Rails.application.routes.draw do
  root 'static_pages#home'

  # Static Pages routes
  get 'help',    to: 'static_pages#help'
  get 'about',   to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'

  # User routes
  get 'signup', to: 'users#new'
end
