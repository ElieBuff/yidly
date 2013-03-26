class Project < ActiveRecord::Base
  attr_accessible :name, :user_id
  validates :name, :uniqueness => {:message => "You cannot have several projects with the same name"}
  has_many :records, :dependent => :destroy
  has_many :stages, :dependent => :destroy
  belongs_to :user
end
