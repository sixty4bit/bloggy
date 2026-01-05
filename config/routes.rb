Rails.application.routes.draw do
  root "pages#home"

  # Dashboard
  get "dashboard", to: "dashboard#show", as: :dashboard

  # Authentication
  resource :session, only: [ :new, :create, :destroy ] do
    scope module: :sessions do
      resource :magic_link, only: [ :show, :create ]
    end
  end

  # Signup
  resource :signup, only: [ :new, :create ] do
    scope module: :signups do
      resource :completion, only: [ :new, :create ]
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
