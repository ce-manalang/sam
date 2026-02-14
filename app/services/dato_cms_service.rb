require "net/http"
require "json"

class DatoCmsService
  API_URL = "https://graphql.datocms.com/"
  API_TOKEN = ENV["DATOCMS_API_TOKEN"]

  def self.fetch_books
    Rails.cache.fetch("datocms_all_books", expires_in: 1.hour) do
      query = <<~GRAPHQL
        {
          allBooks {
            id
            title
            author
          }
        }
      GRAPHQL

      execute_query(query).dig("data", "allBooks")
    end
  end

  def self.fetch_book(id)
    Rails.cache.fetch("datocms_book_#{id}", expires_in: 1.hour) do
      query = <<~GRAPHQL
        query($id: ItemId) {
          book(filter: { id: { eq: $id } }) {
            id
            title
            author
          }
        }
      GRAPHQL

      execute_query(query, { id: id }).dig("data", "book")
    end
  end

  private

  def self.execute_query(query, variables = {})
    uri = URI(API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    if Rails.env.test?
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    request = Net::HTTP::Post.new(uri.path)
    request["Authorization"] = "Bearer #{API_TOKEN}"
    request["Content-Type"] = "application/json"
    request["Accept"] = "application/json"

    request.body = { query: query, variables: variables }.to_json

    response = http.request(request)

    if response.code == "200"
      JSON.parse(response.body)
    else
      raise "DatoCMS API error: #{response.code} - #{response.body}"
    end
  end
end
