# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name 'prj 200'
    association :user, factory: :user, name: 'Test User'
  end
end
