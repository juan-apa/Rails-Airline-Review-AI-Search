# Demo of AI search using OpenAI embeddings
## Usage
1. Clone the repo
1. Run `bundle install`
1. Generate an OpenAI api key, and set the env
```env
OPENAI_API_KEY=sk-sample-api-key
```
4. run rails db:create db:migrate
5. open a `rails c` and run:
```ruby
require 'csv'

# Load the CSV data into a hash
csv_path = Rails.root.join('db', 'airline_reviews_sample.csv')
data = CSV.read(csv_path, headers: true)

# Create Airline records
airlines = data.map { |row| row['Airline'] }.uniq

ActiveRecord::Base.transaction do
  airlines.each { |name| Airline.create(name: name) }

  # Create Review records
  data.each do |row|
    airline = Airline.find_by!(name: row['Airline'])
    Review.create(title: row['Title'], body: row['Reviews'], airline: airline)
  end
end

# Generate the embeddings calling the OpenAI embeddings API
Review.find_each do |review|
  embedding = OpenAi::CreateEmbedding.call(review.embed_string)
  review.create_embedding!(embedding:)
end
```
6. run the development server with `bin/dev`
