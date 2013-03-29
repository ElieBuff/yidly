class Stage < ActiveRecord::Base
  attr_accessible :name, :action, :project_id
  belongs_to :project
  has_many :records
  validates_uniqueness_of :name, :scope => :project_id
end
