class Stage < ActiveRecord::Base
  attr_accessible :name, :action, :project_id
  belongs_to :project
  has_many :records
end
