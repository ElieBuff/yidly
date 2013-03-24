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
3.times {|user_id| 
  user = User.find_or_create_by_email! :id=>user_id, :name => "test_#{user_id}", :email => "test_#{user_id}@yidly.com", :password => "99999999", :password_confirmation => "99999999"
  rand(5).times {|prj_id|
    prj = Project.create! :name => "yidly_prj_#{prj_id}_user_#{user_id}", :user_id=>user_id
    rand(4).times {|i|
      record = Record.create! :name => "Candidate_#{i}_prj_#{prj_id}_user_#{user_id}", :project_id=> prj.id, :status => ["received", "reviewed", "contacted", "meeting_scheduled", "passed_to_manager", "offer", "closed"].sample
      p record
    }
  }
}
