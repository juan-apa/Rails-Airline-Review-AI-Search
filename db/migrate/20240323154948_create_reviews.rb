class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.references :airline, null: false, foreign_key: true

      t.timestamps
    end
  end
end
