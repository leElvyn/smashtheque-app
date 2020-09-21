require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do

  # ADMIN

  devise_config = ActiveAdmin::Devise.config
  devise_config[:controllers][:omniauth_callbacks] = 'admin_users/omniauth_callbacks'
  devise_for :admin_users, devise_config

  ActiveAdmin.routes(self)

  # SIDEKIQ

  mount Sidekiq::Web => '/sidekiq'

  # API

  namespace :api do
    namespace :v1 do
      resources :characters, only: :index
      resources :locations, only: [:index, :create]
      resources :players, only: [:index, :show, :create, :update]
      resources :teams, only: :index
      get '/search' => 'search#global'
    end
  end

  # API DOC

  mount Rswag::Ui::Engine => '/api/docs'
  mount Rswag::Api::Engine => '/api/docs'

  # PUBLIC

  resources :characters, only: :index
  get '/characters/:id' => 'players#character_index', as: :character

  resources :discord_guilds, only: [:index, :show]

  resources :locations, only: :index
  get '/locations/:id' => 'players#location_index', as: :location

  resources :players, only: [:index, :show]

  resources :teams, only: :index
  get '/teams/:id' => 'players#team_index', as: :team

  root to: 'public#home'

end
