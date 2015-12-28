require 'api_constraints'
Rails.application.routes.draw do

  devise_for :users
  namespace :api, :defaults => {format: :json} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, :only => [:show, :create, :update, :destroy]
      resources :sessions, :only => [:create, :destroy]
      resources :groups, :only => [:create]
      resources :invites do
        collection do
          post :accept
        end
      end
    end
  end

end
