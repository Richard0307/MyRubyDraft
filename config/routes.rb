Rails.application.routes.draw do
  get 'mock_interviews/new'
  get 'mock_interviews/create'
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

  resources :mock_interviews
  get '/mock_interviews', to: 'mock_interviews#index'

  # Set the after sign in path to home
  get '/pages/home', to: 'pages#home', as: 'pages_home'

  # Define the staff route here
  get '/staff', to: 'staff#index', as: 'staff_home'

  resources :notifications do
    member do
      put :mark_as_read
    end
  end
  def after_sign_in_path_for(resource)
    pages_home_path
  end
end
