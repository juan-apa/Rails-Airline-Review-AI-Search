class Review < ApplicationRecord
  belongs_to :airline
  has_one :embedding, as: :embeddable

  validates :title, :body, presence: true

  def embed_string
    "#{title} #{body}"
  end
end
