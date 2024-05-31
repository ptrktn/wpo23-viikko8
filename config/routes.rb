Rails.application.routes.draw do
  resources :styles do
    get 'about', on: :collection
  end
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'breweries#index'

  resources :ratings, only: [:index, :new, :create, :destroy, :show]
  resource :session, only: [:new, :create, :destroy]

  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  resources :places, only: [:index, :show]
  post 'places', to: 'places#search'

  get 'breweries/active', to: 'breweries#active'
  get 'breweries/retired', to: 'breweries#retired'
  resources :breweries do
    post 'toggle_activity', on: :member
  end

  resources :users do
    post 'toggle_enabled', on: :member
    get 'recommendation', on: :member
  end

  resources :memberships do
    post 'confirm', on: :member
  end

  get 'beerlist', to: 'beers#list'
  get 'brewerylist', to: 'breweries#list'
end
