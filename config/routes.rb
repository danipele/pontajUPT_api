Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'

      resources :courses, except: [:show]
      resources :projects, except: [:show]
      resources :timelines

      resource :users do
        post :reset_password
        get :authenticated_user
      end

      resource :courses do
        post :destroy_selected
        get :download_template
        post :import_courses
      end

      resource :projects do
        post :destroy_selected
        get :download_template
        post :import_projects
      end
    end
  end
end
