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
  user = User.find_or_create_by_email! :name => "test_#{user_id}", :email => "test_#{user_id}@yidly.com", :password => "99999999", :password_confirmation => "99999999"
  rand(1..5).times {|prj_id|
    prj = Project.find_or_create_by_name! :name => "prj_#{rand(5)}", :user_id=>user.id
    [["received", "review"], ["reviewed", "contact"], ["contacted", "schedule a meeting"], ["meeting_scheduled", "pass to manager"], ["passed to manager",""], ["offer",""], ["closed",""]].each {|stage, action|
      Stage.find_or_create_by_name_and_project_id! :name => stage, :action => action, :project_id => prj.id
    }
    rand(1..4).times {
      Record.create! :name => "Candidate_#{rand(100)}", :stage_id => prj.stages.sample.id
    }
  }
}
Record.all.each {|record|
  puts record.summary
}
