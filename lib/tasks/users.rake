# frozen_string_literal: true

namespace :users do
  desc 'Create default admin user'
  task create_admin: :environment do

    email    = ENV['ADMIN_USER']
    password = ENV['ADMIN_PASSWORD']

    if email.blank? && password.blank?
      require 'io/console'
      print 'Enter admin email: '
      email    = $stdin.gets.chomp
      password = IO.console.getpass('Enter admin password: ').chomp
    end

    User.create!(email: email, password: password, password_confirmation: password).admin!
    puts "Admin user '#{email}' was created!"
  end
end
