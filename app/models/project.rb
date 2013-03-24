class Project < ActiveRecord::Base
  attr_accessible :name
  validates :name, :uniqueness => {:message => "You cannot have several projects with the same name"}
  has_many :records, :dependent => :destroy
end
