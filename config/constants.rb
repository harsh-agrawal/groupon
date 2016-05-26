CONSTANTS = YAML.load_file(Rails.root.join('config', 'constants.yml'))[Rails.env]

REGEXP = {
  email: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
}