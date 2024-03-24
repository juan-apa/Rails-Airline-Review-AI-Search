# frozen_string_literal: true

require 'net/http'

class OpenAi::CreateEmbedding
  def initialize(api_key)
    @api_key = api_key
  end

  def self.call(text)
    new(ENV["OPENAI_API_KEY"]).call(text)
  end

  def call(text)
    response = Net::HTTP.post(
      URI("https://api.openai.com/v1/embeddings"),
      {
        input: text,
        model: "text-embedding-ada-002"
      }.to_json,
      "Authorization" => "Bearer #{@api_key}",
      "Content-Type" => "application/json"
    )

    JSON.parse(response.body)["data"].first["embedding"]
  end
end
