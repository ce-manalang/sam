require "rails_helper"

RSpec.describe DatoCmsService do
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
  end
end
