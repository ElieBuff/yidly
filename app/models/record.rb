class Record < ActiveRecord::Base
  attr_accessible :email, :name, :project_id, :status
  validates_presence_of :name, :project_id
  belongs_to :project
  def summary
     "name: #{self.name}, project: #{self.project.name}, user: #{self.project.user.email}, status: #{self.status}"
  end
  def to_task
    { 
      :action => self.status,
      :name => self.name,
    }
  end
end
