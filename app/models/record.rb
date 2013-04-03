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

  def update_stage_id(id)
    self.update_attributes({
      :stage_id => id,
      :actionable_at => Time.now
    }) unless id == self.id
  end

  def move_to_next_stage
    self.stage.lower_item.tap { |next_stage|
      update_stage_id(next_stage.id) unless next_stage.nil?
    }
    self
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
