class Project < ActiveRecord::Base
  attr_accessible :job_title, :job_description, :user_id, :company, :hiring_manager, :location, :company_icon
  has_many :records, :through => :stages
  has_many :stages, :dependent => :destroy, :order => :position
  belongs_to :user

  def extended
    self.attributes.merge :num_records => self.records_active.length
  end
  def records_active
    records.find(:all, :conditions => "rejected_at is NULL")
  end

  def first_stage
    stages.min {|stage| stage.id}
  end

  def stages_and_records
    {
      :name => "#{self.job_title}  (#{self.location})",
      :stages => self.stages.order(:id).map {|stage|
                          { 
                            :name => stage.name,
                            :id => stage.id,
                            :img => stage.icon
                          }
                 },
      :records => self.records_active.sort_by{ |record|
                   record[:actionable_at]
                 }.map { |r|
                    r.to_task
                  }.to_a.group_by{|task|
                    task[:stage]
                  }
    }
  end
end
