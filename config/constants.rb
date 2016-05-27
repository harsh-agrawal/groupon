CONSTANTS = YAML.load_file('./config/constants.yml')[Rails.env]

REGEXP = {
  email: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
}