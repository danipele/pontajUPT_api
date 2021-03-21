Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      resource :users do
        post :reset_password
        get :authenticated_user
      end
      resources :courses, except: [:show]
      resource :courses do
        post :destroy_selected
        get :download_template
        post :import_courses
      end
      resources :projects, except: [:show]
      resource :projects do
        post :destroy_selected
        get :download_template
        post :import_projects
      end
    end
  end
end
