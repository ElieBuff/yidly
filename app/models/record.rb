class Record < ActiveRecord::Base
  class RecordValidator < ActiveModel::Validator
    def validate(record)
      record.errors[:stage_id] << "Need an existing stage in the project" if record.stage.nil?
    end
  end
  include ActiveModel::Validations
  validates_with RecordValidator
  attr_accessible :email, :name, :stage_id, :actionable_at
  validates_presence_of :name, :stage_id
  default_value_for :actionable_at do
    Time.now
  end
  belongs_to :stage
  delegate :action, :to => :stage
  delegate :project, :to => :stage
  delegate :user, :to => :project

  def summary
     "name: #{self.name}, project: #{self.project.name}, user: #{self.user.email}, stage: #{self.stage.name}"
  end

  def to_task
    { 
      :action => self.action,
      :name => self.name,
      :actionable_at => self.actionable_at,
      :record_id => self.id,
      :stage_id => self.stage.id
    }
  end
end
