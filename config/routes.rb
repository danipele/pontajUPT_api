Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :users do
        post :login
        post :logout
      end
    end
  end
end
