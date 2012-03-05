Railstar::Engine.routes.draw do
  root :to => "general#index"

  match "database" => "general#database"
  match "code" => "general#code"

  resources :feedbacks
end
