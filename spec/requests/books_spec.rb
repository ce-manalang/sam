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
end
