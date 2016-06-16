CONSTANTS = YAML.load_file('./config/constants.yml')[Rails.env]

@countries = JSON.parse(File.read("./lib/countries.json"))
COUNTRIES = @countries.map { |country| country['name'] }

REGEXP = {
  email: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
}