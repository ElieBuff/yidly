class Record < ActiveRecord::Base
  attr_accessible :email, :name, :stage_id
  validates_presence_of :name, :stage_id
  belongs_to :stage
  delegate :action, :to => :stage
  delegate :project, :to => :stage
  delegate :user, :to => :project

  def summary
     "name: #{self.name}, project: #{self.project.name}, user: #{self.user.email}, stage: #{self.stage.name}"
  end
  def action
  end

  def to_task
    { 
      :action => self.action,
      :name => self.name
    }
  end
end
