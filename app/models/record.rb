class Record < ActiveRecord::Base
  attr_accessible :email, :name, :project_id
  validates_presence_of :name, :project_id
  belongs_to :project
end
