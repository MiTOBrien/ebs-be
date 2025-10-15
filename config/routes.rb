Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    passwords: 'users/passwords',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  get 'users', to: 'users#index'
  put 'users/change-password', to: 'users#change_password'
  post 'users/profile-image', to: 'users#upload_profile_image'
  put 'users/:id', to: 'users#update'

  get 'readers', to: 'readers#index'

  get 'genres', to: 'genres#index'

  post 'payments/create_checkout_session', to: 'payments#create_checkout_session'
  post 'webhooks/stripe', to: 'webhooks#stripe'

  get 'admin/role_summary', to: 'admin#role_summary'
  patch 'admin/users/:id/enable', to: 'users#enable'
  patch 'admin/users/:id/disable', to: 'users#disable'
  get 'admin/genres', to: 'genres#index'
  post 'admin/genres', to: 'genres#create'
  patch 'admin/genres/:id', to: 'genres#update'
end
