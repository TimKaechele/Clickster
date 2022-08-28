Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      scope 'docs' do
        root 'docs#show'
        get 'openapi.yml', to: 'docs#openapi', as: :open_api
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
