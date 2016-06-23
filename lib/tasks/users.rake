namespace :users do
  desc "generate authentication_token"
  task authentication_token: :environment do

    User.verified.find_each do |user|
      if user.authentication_token.blank?
        user.generate_token(:authentication_token)
        if user.save
          puts "Authentication token has been generated and saved for the user #{ user.first_name } with id #{ user.id }"
        else
          puts "Failed to save authentication_token for the user #{ user.first_name } with id #{ user.id }"
        end
      end
    end
  end

end
