Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :recipes, only: [:index, :show] do
        # add custom actions here later if needed, e.g.,
        # collection do
        #   get :search
        # end
      end
    end
  end
end