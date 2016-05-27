namespace :admin do
  desc "create an admin"
  task new: :environment do
    user = User.new

    user.admin = true
    
    puts "Enter Your First Name"
    user.first_name = get_input
    
    puts "Enter Your Last Name"
    user.last_name = get_input
    
    puts "Enter Your Email Id"
    user.email = get_input
    
    puts "Enter Your Password"
    user.password = get_input
    
    puts "Re-enter Your Password"
    user.password_confirmation = get_input

    user.verified_at = Time.current
    
    if user.save
      puts "Admin successfully created"
    else
      puts 'Errors'
      puts user.errors.full_messages.to_sentence
    end
  end

  def get_input
    STDIN.gets.strip
  end

end
