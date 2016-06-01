namespace :merchant do
  desc "seed merchants to database"
  task seed: :environment do

    records = JSON.parse(File.read("./lib/merchants.json"))

    records.each do |record|
      merchant = Merchant.new
      merchant.name = record["name"]
      merchant.email = record["email"]
      merchant.password = record["password"]
      merchant.errors.full_messages.to_sentence unless merchant.save
    end

  end

end
