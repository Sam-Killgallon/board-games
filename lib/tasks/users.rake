# frozen_string_literal: true

namespace :users do
  desc 'Create default admin user'
  task create_admin: :environment do
    require 'io/console'

    print 'Enter admin email: '
    email = $stdin.gets.chomp
    password = IO.console.getpass('Enter admin password: ').chomp

    User.create!(email: email, password: password, password_confirmation: password).admin!
    puts "User '#{email}' was created!"
  end
end
