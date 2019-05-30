# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  devise_for :users

  resources :games, except: %i[create edit]

  resources :game_sessions, only: %i[index create show update] do
    resources :users, only: %i[create update], controller: 'game_sessions/users'
  end

  namespace :admin do
    root 'home#index'
    resources :games
    resources :users, only: %i[index show]
  end
end
