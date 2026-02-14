class BooksController < ApplicationController
  # This skips auth for the public list
  before_action :authenticate_user!, except: [ :index ]

  def index
    render json: DatoCmsService.fetch_books
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
