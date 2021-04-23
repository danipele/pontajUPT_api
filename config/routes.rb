# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'

      resources :courses, except: [:show]
      resources :projects, except: [:show]
      resources :events

      resource :users do
        post :reset_password
        get :authenticated_user
      end

      resource :courses do
        post :destroy_selected
        post :download_template
        post :import_courses
        post :export_courses
      end

      resource :projects do
        post :destroy_selected
        post :download_template
        post :import_projects
        post :export_projects
      end

      resource :events do
        post :destroy_selected
        post :copy_events
        post :copy_event
      end
    end
  end
end
