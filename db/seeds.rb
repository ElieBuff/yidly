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
      ["Review", "review", "/assets/actions/review.jpg"], 
      ["Initial Contact", "contact", "/assets/actions/email.jpg"], 
      ["Phone Screen", "schedule a meeting", "/assets/actions/phone_interview.jpg"], 
      ["First Interview", "pass to manager", "/assets/actions/hiring_manager.jpg"], 
      ["Further Interviews","wait", "/assets/actions/panel_interview.jpg"], 
      ["Decision","wait", "/assets/actions/decision.jpg"], 
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
  ["Manager, Media Relations", "John Smith", "HP", "http://picsoff.com/files/funzug/imgs/informative/co_logos_mean_09.jpg", "New York"],
  ["Manager, Professional Activities", "Fred Appleseed", "Green Apple", "http://www.logodesigncompanyindia.com/images/logo/green-apple.jpg", "Boston"],
  ["Jr Business Analyst", "Bill Timothey", "Toyota", "http://1.bp.blogspot.com/-6vatOqS9mBM/UShnnEJvqdI/AAAAAAAACX4/2cjvw5wkPQA/s1600/Toyota_logo1.jpg", "San Francisco"],
  ["Production Editor", "Frank Redley", "Google", "http://images3.wikia.nocookie.net/__cb20100520131748/logopedia/images/5/5c/Google_logo.png", "Los Angeles"],
  ["Software Engineer", "Jennifer Madison", "Apple", "http://edibleapple.com/wp-content/uploads/2009/04/silver-apple-logo.png", "Miami"],
  ["Web Designer", "Sam Liam", "P&G", "http://www.pgnewsroom.co.uk/sites/pguk.newshq.businesswire.com/files/press_release/file/PG_NEWPHASE_LOGO_RGB_HR.jpg", "Palo Alto"]
].shuffle
3.times {|user_id| 
  user = User.create! :name => "test_#{user_id}", :email => "test_#{user_id}@yidly.com", :password => "99999999", :password_confirmation => "99999999"
  5.times {|prj_id|
  puts "project user.id: #{user.id}"
    prj = Project.create! :job_title => projects[prj_id][0], 
                          :hiring_manager => projects[prj_id][1], 
                          :company => projects[prj_id][2],
                          :company_icon => projects[prj_id][3],
                          :location => projects[prj_id][4],
                          :user_id=>user.id
    stages.each {|stage, action, icon|
      Stage.create! :name => stage, :action => action, :icon => icon, :project_id => prj.id
    }
    rand(4..10).times {|candidate_id|
      stage = prj.stages.sample
      puts "stage user: #{stage.user.name}"
      Record.create! :name => candidate_names[candidate_id], :stage_id => stage.id
    }
  }
}
Record.all.each {|record|
  puts record.summary
}
