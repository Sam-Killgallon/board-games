# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  devise_for :users

  resources :games, only: %i[index new create destroy]
  resources :game_sessions, only: %i[create show update] do
    resource :users, only: [:update], controller: 'game_sessions/users'
  end

  namespace :admin do
    root 'home#index'
    resources :games
  end
end
