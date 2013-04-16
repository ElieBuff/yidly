# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html

stages = [
     ["received", "review", "http://www.tienganh123.com/file/luyen-thi-toeic/part3%20practice/test%204.jpg"], 
     ["reviewed", "contact", "http://www.skinz.org/free-clipart/email-graphics/envelope-circle-clipart.gif"], 
     ["contacted", "schedule a meeting", "http://www.rock.k12.nc.us//cms/lib6/NC01000985/Centricity/Domain/153/Phone.jpg"], 
     ["meeting_scheduled", "pass to manager", "http://www.best-of-web.com/_images_300/Realistic_Style_Quarterback_Throwing_the_Football_100308-164108-094042.jpg"], 
     ["passed to manager",""], 
     ["offer",""], 
     ["closed",""]
    ]
candidate_names = [
"Steve Bolhman",
"Jeff Griffis",
"Cody Blagg",
"Curtis Uyemoto",
"Stephanie Bolhmann",
"Eric Greenwood",
"Jacob Blagg",
"Allisa Griffis",
"Justin Griffis",
"Justin Vue",
"Just Rushlo",
"Jessica Steffani",
"Rosa Villa",
"Kara Warren",
"Vanessa Uribe",
"Kayla Strout",
"Joseph Stockman",
].shuffle
projects = [
  "Manager, Media Relations",
  "Manager, Professional Activities",
  "Jr Business Analyst",
  "Production Editor",
  "Software Engineer",
  "Web Designer"
].shuffle
3.times {|user_id| 
  user = User.create! :name => "test_#{user_id}", :email => "test_#{user_id}@yidly.com", :password => "99999999", :password_confirmation => "99999999"
  rand(1..5).times {|prj_id|
  puts "project user.id: #{user.id}"
    prj = Project.create! :name => projects[prj_id], :user_id=>user.id
    stages.each {|stage, action, icon|
      Stage.create! :name => stage, :action => action, :icon => icon, :project_id => prj.id
    }
    rand(1..4).times {|candidate_id|
      stage = prj.stages.sample
      puts "stage user: #{stage.user.name}"
      Record.create! :name => candidate_names[candidate_id], :stage_id => stage.id
    }
  }
}
Record.all.each {|record|
  puts record.summary
}
