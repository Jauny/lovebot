Rails.application.routes.draw do
  get 'welcome/index'

  get '/auth/twitter/callback', to: 'accounts#create'
  post 'accounts/:id/spread_the_love', to: 'accounts#spread_the_love', as: :account_spread_the_love
  post 'accounts/:id/stop', to: 'accounts#stop', as: :account_stop
  post 'accounts/lgout', to: 'accounts#logout', as: :account_logout


  root to: 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
