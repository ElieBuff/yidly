class Project < ActiveRecord::Base
  attr_accessible :job_title, :job_description, :user_id, :company, :hiring_manager, :location, :company_icon
  has_many :records, :through => :stages
  has_many :stages, :dependent => :destroy, :order => :position
  belongs_to :user

  def extended
    self.attributes.merge :num_records => records.find(:all, :conditions => "rejected_at is NULL").length
  end

  def first_stage
    stages.min {|stage| stage.id}
  end

  def stages_and_records
    {
      :name => self.name,
      :stages => self.stages.order(:id).map {|stage|
                    stage.name
                 },
      :records => self.records.map { |r| 
                    r.to_task
                  }.to_a.group_by{|task|
                    task[:stage]
                  }
    }
  end
end
