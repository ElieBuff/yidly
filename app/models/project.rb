class Project < ActiveRecord::Base
  attr_accessible :name, :user_id
  validates :name, :uniqueness => {:message => "You cannot have several projects with the same name", :scope => :user_id}
  has_many :records, :dependent => :destroy
  has_many :stages, :dependent => :destroy, :order => :position
  belongs_to :user

  def first_stage
    stages.min {|stage| stage.id}
  end
end
