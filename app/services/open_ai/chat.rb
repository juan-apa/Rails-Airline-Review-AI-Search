# frozen_string_literal: true

require 'net/http'

class OpenAi::Chat
  def initialize(api_key)
    @api_key = api_key
  end

  def self.call(prompt, **kwargs)
    new(ENV["OPENAI_API_KEY"]).call(prompt, **kwargs)
  end

  def call(prompt, **kwargs)
    messages = [{ role: 'user', content: prompt }]
    kwargs.each do |role, content|
      messages << { role:, content: }
    end

    response = Net::HTTP.post(
      URI("https://api.openai.com/v1/chat/completions"),
      {
        model: "gpt-3.5-turbo",
        messages: messages
      }.to_json,
      "Authorization" => "Bearer #{@api_key}",
      "Content-Type" => "application/json"
    )

    JSON.parse(response.body)["choices"]&.first&.dig("message", "content")
  end
end
