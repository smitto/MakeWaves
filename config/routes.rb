Rails.application.routes.draw do

  # Override default sign_in path
  # Hack to get around some unexpected devise behavior
  devise_scope :user do
    get "/users/sign_in" => redirect("/"), :via => [:get]
  end

  devise_for :users, :controllers => { registrations: 'registrations'}
  devise_scope :user do
    #get '/sign-in', to: redirect("/"), as: "login"
    match '/sign-in' => redirect("/"), :via => [:all], :as => :login
    match 'users/sign_in' => redirect("/"), :via => [:all]
  end

  resources :users do
  	resources :songs
    resources :playlists do
      get 'songs', to: 'playlist_songs#index'
      post 'songs', to: 'playlist_songs#create'
      delete 'songs', to: 'playlist_songs#destroy'
    end
    post '/api/addSongToHistory' => 'users#add_to_history'
  end

  authenticated :user do
  	root 'users#dashboard', as: "authenticated_root"
  end

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :relationships,       only: [:create, :destroy]

  root 'welcome#index'
  #match "*" => redirect("/"), :via=>[:all]
end
