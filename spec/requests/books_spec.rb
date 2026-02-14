require "rails_helper"

RSpec.describe "Books", type: :request do
  let!(:user) { User.create!(email: "test@example.com", password: "password") }
  let!(:book) { Book.create!(title: "Mr Salary", author: "Sally Rooney", is_public: true, user: user) }

  describe "GET /books" do
    let(:mock_dato_books) do
      [ {
        "id" => "ex7XI1oCTES8Zt9i1TspUA",
        "title" => "Mr Salary",
        "author" => "Sally Rooney",
        "isbn" => "1234567890",
        "description" => "A short story",
        "cover" => { "url" => "http://example.com/cover.jpg" }
      } ]
    end

    before do
      allow(DatoCmsService).to receive(:fetch_books).and_return(mock_dato_books)
    end

    it "returns a list of public books from DatoCMS" do
      get "/books"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.count).to eq(1)

      salary = json.first
      expect(salary["title"]).to eq("Mr Salary")
      expect(salary["id"]).to eq("ex7XI1oCTES8Zt9i1TspUA")
      expect(salary).to have_key("cover")
    end
  end

  describe "GET /books/:id" do
    let(:book_id) { "ex7XI1oCTES8Zt9i1TspUA" }
    let(:mock_dato_book) do
      {
        "id" => book_id,
        "title" => "Mr Salary",
        "author" => "Sally Rooney",
        "isbn" => "1234567890",
        "description" => "A short story",
        "cover" => { "url" => "http://example.com/cover.jpg" },
        "tags" => "Fiction, Short Story"
      }
    end

    before do
      allow(DatoCmsService).to receive(:fetch_book).with(book_id).and_return(mock_dato_book)
    end

    context "when unauthenticated" do
      it "returns book metadata" do
        get "/books/#{book_id}"

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["title"]).to eq("Mr Salary")
        expect(json).not_to have_key("in_library")
      end
    end

    context "when authenticated" do
      before do
        post user_session_path, params: { user: { email: user.email, password: user.password } }, headers: { "Accept" => "application/json" }
        @token = response.headers['Authorization']
      end

      it "returns book metadata with in_library: true if in library" do
        LibraryBook.create!(user: user, dato_book_id: book_id, status: "read", notes: "Great book")

        get "/books/#{book_id}", headers: { "Authorization" => @token }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["in_library"]).to be true
        expect(json["library_status"]).to eq("read")
        expect(json["library_notes"]).to eq("Great book")
      end

      it "returns book metadata with in_library: false if not in library" do
        get "/books/#{book_id}", headers: { "Authorization" => @token }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["in_library"]).to be false
      end
    end
  end
end
