require "net/http"
require "json"

class DatoCmsService
  API_URL = "https://graphql.datocms.com/"
  API_TOKEN = ENV["DATOCMS_API_TOKEN"]

  def self.fetch_books
    uri = URI(API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    # Skip SSL verification in test environment if needed for CRL issues
    if Rails.env.test?
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    request = Net::HTTP::Post.new(uri.path)
    request["Authorization"] = "Bearer #{API_TOKEN}"
    request["Content-Type"] = "application/json"
    request["Accept"] = "application/json"

    query = <<~GRAPHQL
      {
        allBooks {
          id
          title
          author
        }
      }
    GRAPHQL

    request.body = { query: query }.to_json

    response = http.request(request)

    if response.code == "200"
      JSON.parse(response.body).dig("data", "allBooks")
    else
      raise "DatoCMS API error: #{response.code} - #{response.body}"
    end
  end
end
