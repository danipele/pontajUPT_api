Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      resource :users do
        post :reset_password
        get :authenticated_user
      end
      resource :courses
    end
  end
end
