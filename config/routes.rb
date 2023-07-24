# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post 'signin', to: 'sessions#create'
      post 'signup', to: 'registrations#create'

      post 'users', to: 'user#create'

      resources :batches, only: %i[index]
      resources :courses, only: %i[index show]
      resources :schools, only: %i[index show]

      namespace :student do
        resources :batches, only: %i[index show]
        resources :courses, only: %i[index show]
        resources :enrollments, only: %i[index create destroy]
      end
    end
  end

  root 'home#index'

  namespace :admin do
    get '', to: 'dashboard#index', as: '/'

    resources :batches
    resources :courses
    resources :enrollments, only: %i[index new create update]

    resources :schools do
      resources :admins, only: %i[index new create destroy], module: :schools
    end

    resources :users, except: :show
  end

  resources :batches, only: %i[index]
  resources :courses, only: %i[index show]
  resources :schools, only: %i[index show]

  namespace :student do
    resources :batches, only: %i[index show]
    resources :courses, only: %i[index show]
    resources :enrollments, only: %i[index create destroy]
  end
end
