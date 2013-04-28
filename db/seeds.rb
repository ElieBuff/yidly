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
     ["Review", "review", "http://www.tienganh123.com/file/luyen-thi-toeic/part3%20practice/test%204.jpg"], 
     ["Intial Contact", "contact", "http://www.skinz.org/free-clipart/email-graphics/envelope-circle-clipart.gif"], 
     ["Phone Screen", "schedule a meeting", "http://www.rock.k12.nc.us//cms/lib6/NC01000985/Centricity/Domain/153/Phone.jpg"], 
     ["First Interview", "pass to manager", "http://www.best-of-web.com/_images_300/Realistic_Style_Quarterback_Throwing_the_Football_100308-164108-094042.jpg"], 
     ["Further Interviews",""], 
     ["Decision",""]
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
  ["Manager, Media Relations", "John Smith"],
  ["Manager, Professional Activities", "Fred Appleseed"],
  ["Jr Business Analyst", "Bill Timothey"],
  ["Production Editor", "Frank Redley"],
  ["Software Engineer", "Jennifer Madison"],
  ["Web Designer", "Sam Liam"]
].shuffle
3.times {|user_id| 
  user = User.create! :name => "test_#{user_id}", :email => "test_#{user_id}@yidly.com", :password => "99999999", :password_confirmation => "99999999"
  rand(1..5).times {|prj_id|
  puts "project user.id: #{user.id}"
    prj = Project.create! :name => projects[prj_id][0], :hiring_manager => projects[prj_id][1], :user_id=>user.id
    stages.each {|stage, action, icon|
      Stage.create! :name => stage, :action => action, :icon => icon, :project_id => prj.id
    }
    rand(1..10).times {|candidate_id|
      stage = prj.stages.sample
      puts "stage user: #{stage.user.name}"
      Record.create! :name => candidate_names[candidate_id], :stage_id => stage.id
    }
  }
}
Record.all.each {|record|
  puts record.summary
}
