Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'questions#index'

  get 'search', to: 'search#index', as: :search

  concern :commentable do
    resources :comments
  end

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end

      resources :questions, shallow: true do
        resources :answers
      end
    end
  end

  resources :questions, concerns: :commentable, shallow: true do
    get 'search', on: :collection
    resources :answers, concerns: :commentable do
      get 'search', on: :collection
    end
  end

  resources :subscriptions, only: [:create, :destroy]
end
