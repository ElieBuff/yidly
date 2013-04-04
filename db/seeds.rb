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
  user = User.create! :name => "test_#{user_id}", :email => "test_#{user_id}@yidly.com", :password => "99999999", :password_confirmation => "99999999"
  rand(1..5).times {|prj_id|
  puts "project user.id: #{user.id}"
    prj = Project.create! :name => "prj_#{prj_id}", :user_id=>user.id
    [["received", "review"], ["reviewed", "contact"], ["contacted", "schedule a meeting"], ["meeting_scheduled", "pass to manager"], ["passed to manager",""], ["offer",""], ["closed",""]].each {|stage, action|
      Stage.create! :name => stage, :action => action, :project_id => prj.id
    }
    rand(1..4).times {|candidate_id|
      stage = prj.stages.sample
      puts "stage user: #{stage.user.name}"
      Record.create! :name => "Candidate_#{candidate_id}", :stage_id => stage.id
    }
  }
}
Record.all.each {|record|
  puts record.summary
}
