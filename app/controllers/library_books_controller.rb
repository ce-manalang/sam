class LibraryBooksController < ApplicationController
  before_action :authenticate_user!

  def create
    @library_book = current_user.library_books.new(library_book_params)

    if @library_book.save
      render json: @library_book, status: :created
    else
      if @library_book.errors.added?(:dato_book_id, :taken, value: params[:dato_book_id]) ||
         @library_book.errors[:dato_book_id].include?("already in library")
        render json: { error: "Book already in library" }, status: :conflict
      else
        render json: { errors: @library_book.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def library_book_params
    params.require(:library_book).permit(:dato_book_id, :status, :notes)
  end
end
