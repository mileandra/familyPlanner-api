require 'api_constraints'
Rails.application.routes.draw do

  devise_for :users
  namespace :api, :defaults => {format: :json} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, :only => [:show, :create, :update, :destroy]
      resources :sessions, :only => [:create, :destroy]
      resources :groups, :only => [:create, :show] do
        post :remove_member, :on => :collection
      end
      resources :invites do
        collection do
          post :accept
        end
      end
      resources :todos do
        collection do
          post :archive
        end
      end
      resources :messages, :only => [:index, :create, :update, :destroy]
    end
  end

end
