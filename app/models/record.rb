class Record < ActiveRecord::Base
  class RecordValidator < ActiveModel::Validator
    def validate(record)
      record.errors[:stage_id] << "Need an existing stage in the project" if record.stage.nil?
    end
  end
  include ActiveModel::Validations
  validates_with RecordValidator
  attr_accessible :email, :name, :stage_id, :actionable_at, :reschedule_count, :trial_count, :status
  validates_presence_of :name, :stage_id
  default_value_for :trial_count, 0
  default_value_for :reschedule_count, 0
  default_value_for :status, 'active'
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
      :reschedule_count => 0,
      :trial_count => 0,
      :status => 'active',
      :actionable_at => Time.now
    }) unless id == self.id
  end

  def wait_for_sec(delay)
    self.update_attributes({
      :actionable_at => Time.now + delay,
      :trial_count => self.trial_count + 1,
      :status => 'waiting'
    })
    self
  end

  def reschedule_in_sec(delay)
    self.update_attributes({
      :actionable_at => Time.now + delay,
      :reschedule_count => self.reschedule_count + 1,
      :status => 'rescheduled'
    })
    self
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
      :trial_count => self.trial_count,
      :actionable_at => self.actionable_at,
      :trial_count => self.trial_count,
      :reschedule_count => self.reschedule_count,
      :id => self.id
    }
  end
end
