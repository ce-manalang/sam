Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }

  # Public books (anyone can see)
  get "/public_books", to: "books#index"

  # Private books (only for you)
  get "/my_books", to: "books#my_catalog"

  resources :books
  resources :library_books, only: [ :index, :create, :destroy ]

  # Health check
  get "/health", to: ->(env) { [ 200, { "Content-Type" => "application/json" }, [ { status: "ok" }.to_json ] ] }
end
