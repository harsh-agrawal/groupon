CONSTANTS = YAML.load_file('./config/constants.yml')[Rails.env]

@countries = JSON.parse(File.read("./lib/countries.json"))
COUNTRIES = @countries.map { |country| country['name'] }

PUBLISHABLE_KEY = 'pk_test_kceo2PT6Taixdi9qraRnMPQo'
SECRET_KEY = 'sk_test_KwUhom9yTKUJUV0Apxera9O6'

REGEXP = {
  email: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
}