Rails.application.routes.draw do
  get 'pages/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'pages#index'

  namespace :api do
    namespace :v1 do
      resources :countries, param: :name, only: [:index, :show] do
        collection do 
          get :travel_advisory
          get :owid_stats, param: :name
          get :reopenEU, param: :name
          get :embassy_information, param: :name
        end

      end
      # resources :documents, param: :country_id
    end
  end

  get '*path', to: 'pages#index', via: :all
end
