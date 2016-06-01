namespace :categories do
  desc "seed categories to database"
  task seed: :environment do

    records = JSON.parse(File.read("./lib/categories.json"))

    records.each do |record|
      category = Category.new
      category.name = record["name"]
      category.errors.full_messages.to_sentence unless category.save
    end

  end

end
