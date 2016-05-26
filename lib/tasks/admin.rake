namespace :admin do
  desc "create an admin"
  task new: :environment do
    user = User.new

    user.admin = true
    
    puts "Enter Your First Name"
    user.first_name = STDIN.gets.strip
    
    puts "Enter Your Last Name"
    user.last_name = STDIN.gets.strip
    
    puts "Enter Your Email Id"
    user.email = STDIN.gets.strip
    
    puts "Enter Your Password"
    user.password = STDIN.gets.strip
    
    puts "Re-enter Your Password"
    user.password_confirmation = STDIN.gets.strip

    user.verified_at = Time.current
    
    if user.save
      puts "Admin successfully created"
    else
      puts 'Errors'
      user.errors.full_messages.each { |msg| puts msg }
    end
  end
end
