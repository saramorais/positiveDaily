Rails.application.routes.draw do
 
  root to: 'messages#index'

  get "users/verify", to: 'users#show_verify', as: 'verify'
  post "users/verify"
  post "users/resend"

  resources :users, except: [:index]

  resources :messages, only: [:index, :show]

  get 'sessions/new' => 'sessions#new'
  post 'sessions' => 'sessions#create'
  delete 'sessions' => 'sessions#destroy'
 
end
