# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stage do
    name "Start"
    association :project, factory: :project, name: "my prj for test" 
  end
end
