Rails.application.routes.draw do
  get 'chats/show'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }
  root 'homes#top'
  get 'home/about' => 'homes#about'
  resources :users, only: [:show, :index, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  get '/search' => 'search#search'

  get 'chat/:id' => 'chats#show', as: 'chat'
  resources :chats, only: [:create]
end
