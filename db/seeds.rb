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
