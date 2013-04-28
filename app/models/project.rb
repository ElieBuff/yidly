class Project < ActiveRecord::Base
  attr_accessible :name, :user_id
  validates :name, :uniqueness => {:message => "You cannot have several projects with the same name", :scope => :user_id}
  has_many :records, :through => :stages
  has_many :stages, :dependent => :destroy, :order => :position
  belongs_to :user

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
