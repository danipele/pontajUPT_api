Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :users do
        post :login
        post :logout
        post :reset_password
        get :authenticated_user
      end
    end
  end
end
