# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html
puts 'CREATE DEFAULT USERS'
(1..10).each {|id| 
  user = User.find_or_create_by_email! :id=>id, :name => "test_#{id}", :email => "test_#{id}@yidly.com", :password => "99999999", :password_confirmation => "99999999"
  puts "user: #{user.name}, email: #{user.email}"
  prj = Project.create! :name => "yidly_prj_#{id}", :user_id=>id
  puts "project: #{prj.inspect}"
}
