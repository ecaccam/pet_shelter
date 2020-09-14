Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "pets#index"  

  get "/pets/new"      => "pets#manage"
  get "/pets/:id/edit" => "pets#manage"

  post "/add_pet"      => "pets#add_pet"
  post "/update_pet"   => "pets#update_pet"
  post "/fetch_pet"    => "pets#fetch_pet"
  post "/adopt_pet"    => "pets#adopt_pet"
end
