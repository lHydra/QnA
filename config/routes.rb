Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'questions#index'

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
    resources :answers, concerns: :commentable
  end

  resources :subscriptions, only: [:create, :destroy]
end
