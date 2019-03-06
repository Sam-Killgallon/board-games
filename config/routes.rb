# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  devise_for :users

  namespace :admin do
    root 'home#index'
    resources :games
  end
end
