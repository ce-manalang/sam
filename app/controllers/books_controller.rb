class BooksController < ApplicationController
  # This skips auth for the public list
  before_action :authenticate_user!, except: [ :index, :show ]

  def index
    render json: DatoCmsService.fetch_books
  end

  def show
    dato_book = DatoCmsService.fetch_book(params[:id])

    if dato_book
      response_data = dato_book.as_json

      if current_user
        library_book = current_user.library_books.find_by(dato_book_id: params[:id])
        if library_book
          response_data = response_data.merge(
            library_status: library_book.status,
            library_notes: library_book.notes,
            in_library: true
          )
        else
          response_data[:in_library] = false
        end
      end

      render json: response_data
    else
      render json: { error: "Book not found" }, status: :not_found
    end
  end

  def my_catalog
    books = current_user.books
    dato_books = DatoCmsService.fetch_books

    enriched_books = books.map do |book|
      dato_data = dato_books.find do |db|
        db["title"].to_s.strip.casecmp?(book.title.to_s.strip) &&
          db["author"].to_s.strip.casecmp?(book.author.to_s.strip)
      end
      # Keep the local database ID but merge other metadata
      book.as_json.merge(dato_data&.except("id") || {})
    end

    render json: enriched_books
  end
end
