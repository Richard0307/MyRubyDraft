Rails.application.routes.draw do
  # Wrap Devise routes in a devise_scope block
  devise_for :users
  delete '/logout', to: 'sessions#destroy'
  # Defines the root path route ("/")
  root to: 'pages#home'
  authenticated :user do
    root 'pages#home', as: :student_root
  end
  authenticated :user, ->(u) { u.is_staff? } do
    root to: 'staff#index', as: :staff_root
    get '/statistics', to: 'staff#statistics', as: :staff_statistics
  end

  # cancel route
  # resources :products # Add this line
  # resources :categories
  resources :notifications
  get '/notifications', to: 'notifications#index'
  resources :myapplications
  get '/my_applications', to: 'my_applications#index'
  resources :updateprofiles
  get '/updateprofile', to: 'updateprofiles#index'

  # Set the after sign in path to home
  get '/pages/home', to: 'pages#home', as: 'pages_home'

  # Define the staff route here
  get '/staff', to: 'staff#index', as: 'staff_home'

  def after_sign_in_path_for(resource)
    pages_home_path
  end
end
