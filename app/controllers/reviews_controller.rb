class ReviewsController < ApplicationController
  def index
    @reviews = prompt.present? ? reviews : Review.none
    @completions_response = @reviews.any? ? completions_response : nil
  end

  private

  def prompt
    params[:query]
  end

  def prompt_embedding
    OpenAi::CreateEmbedding.call(prompt)
  end

  def matching_embeddings
    if prompt.present?
      Embedding.nearest_neighbors(:embedding, prompt_embedding, distance: :cosine)
    else
      Embedding.all
    end
  end

  def reviews
    embeddings = matching_embeddings
                          .where(embeddable_type: "Review")
                          .limit(7)
                          .pluck(:embeddable_id)
    Review.where(id: embeddings).includes(:airline)
  end

  def completions_response
    system = <<-PROMPT.gsub("\n", "  ")
    You are an AI that answers user submitted questions, based off of the reviews of airlines.
    If you don't have enough information to answer the question, just respond with "I don't have enough information to answer that question."
    Here are the reviews:
      #{ @reviews.map { "- #{_1.airline.name}: #{_1.title}; {_1.body}" }}
    PROMPT

    OpenAi::Chat.call(prompt, system:)
  end
end
