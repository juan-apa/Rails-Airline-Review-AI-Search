class Embedding < ApplicationRecord
  has_neighbors :embedding

  belongs_to :embeddable, polymorphic: true
  validates :embeddable_id, uniqueness: { scope: :embeddable_type }
end
