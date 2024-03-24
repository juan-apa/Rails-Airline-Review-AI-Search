class CreateEmbeddings < ActiveRecord::Migration[7.1]
  def change
    create_table :embeddings do |t|
      t.vector :embedding, null: false
      t.references :embeddable, polymorphic: true, null: false

      t.timestamps
      t.index [:embeddable_type, :embeddable_id], unique: true
    end
  end
end
