# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stage do |f|
    f.sequence(:name) {|n| 
      "Stage #{n}"
    }
  end
end
