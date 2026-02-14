require 'rails_helper'

RSpec.describe "LibraryBooks", type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let(:headers) { { "Accept" => "application/json" } }

  describe "POST /library_books" do
    let(:valid_params) do
      {
        library_book: {
          dato_book_id: "12345",
          notes: "My favorite book",
          status: "owned"
        }
      }
    end

    context "when authenticated" do
      before do
        # Simulating authentication. Devise-jwt might need a token, but for standard RSpec request specs
        # we can sometimes use sign_in(user) if devise-rails is configured, or just bypass if needed.
        # Since this is a JWT app, we might need to actually generate a token.
        # Let's try simple sign_in first if available, or just mock current_user if possible.
        # Given the config, we'll probably need a JWT token.
        post user_session_path, params: { user: { email: user.email, password: user.password } }, headers: headers
        @token = response.headers['Authorization']
      end

      it "creates a new LibraryBook" do
        expect {
          post "/library_books", params: valid_params, headers: headers.merge("Authorization" => @token)
        }.to change(LibraryBook, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it "returns 409 Conflict if book already exists in library" do
        LibraryBook.create!(user: user, dato_book_id: "12345")

        post "/library_books", params: valid_params, headers: headers.merge("Authorization" => @token)

        expect(response).to have_http_status(:conflict)
        expect(JSON.parse(response.body)["error"]).to eq("Book already in library")
      end
    end

    context "when unauthenticated" do
      it "returns 401 Unauthorized" do
        post "/library_books", params: valid_params, headers: headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
