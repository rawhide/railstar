Rails.application.routes.draw do
  root :to => "general#index"

  resources :projects
  resources :tasks
  mount Railstar::Engine => "/railstar"
end
