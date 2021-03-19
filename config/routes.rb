Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      resource :users do
        post :reset_password
        get :authenticated_user
      end
      resources :courses
      resource :courses do
        post :destroy_selected
      end
      resources :projects
      resource :projects do
        post :destroy_selected
      end
    end
  end
end
