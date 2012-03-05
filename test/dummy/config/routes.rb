Rails.application.routes.draw do
  root :to => "general#index"

  resources :tasks
  resources :projects

  mount Railstar::Engine => "/railstar"
end
