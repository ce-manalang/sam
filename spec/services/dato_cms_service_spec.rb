require "rails_helper"

RSpec.describe DatoCmsService do
  before do
    Rails.cache.clear
  end

  describe ".fetch_books" do
    it "returns a list of books from DatoCMS", vcr: { cassette_name: "datocms/fetch_books" } do
      books = described_class.fetch_books

      expect(books).not_to be_nil
      expect(books).to be_an(Array)

      if books.any?
        book = books.first
        expect(book["id"]).not_to be_nil
        expect(book["title"]).not_to be_nil
        expect(book["author"]).not_to be_nil
      end
    end

    it "caches the response", vcr: { cassette_name: "datocms/fetch_books" } do
      expect(Rails.cache).to receive(:fetch).with("datocms_all_books", expires_in: 1.hour).and_call_original
      described_class.fetch_books
    end
  end

  describe ".fetch_book" do
    let(:book_id) { "Jm6ugdGzTtu7jBsIQOVNSQ" } # A valid ID from fetch_books.yml

    it "returns a single book from DatoCMS", vcr: { cassette_name: "datocms/fetch_book" } do
      book = described_class.fetch_book(book_id)

      expect(book).not_to be_nil
      expect(book["id"]).to eq(book_id)
      expect(book).to have_key("title")
      expect(book).to have_key("author")
    end

    it "caches the response", vcr: { cassette_name: "datocms/fetch_book" } do
      expect(Rails.cache).to receive(:fetch).with("datocms_book_#{book_id}", expires_in: 1.hour).and_call_original
      described_class.fetch_book(book_id)
    end
  end
end
