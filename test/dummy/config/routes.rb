Rails.application.routes.draw do
  root :to => "general#index"

  resources :projects do
    resources :tasks
  end
  mount Railstar::Engine => "/railstar"
end
