Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }

  # Public books (anyone can see)
  get "/public_books", to: "books#index"

  # Private books (only for you)
  get "/my_books", to: "books#my_catalog"

  resources :books
end
