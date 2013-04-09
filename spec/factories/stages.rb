# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stage do |f|
    f.sequence(:name) {|n| 
      "Stage #{n}"
    }
    #f.association :project, factory: :project, name: "my prj for test" 
    f.association :project
  end
end
