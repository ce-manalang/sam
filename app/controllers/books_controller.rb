class BooksController < ApplicationController
  # This skips auth for the public list
  before_action :authenticate_user!, except: [ :index ]

  def index
    @books = Book.where(is_public: true)
    render json: @books
  end

  def my_catalog
    # 'current_user' is provided by Devise once you log in
    @books = current_user.books
    render json: @books
  end
end
