class Stage < ActiveRecord::Base
  attr_accessible :name, :action, :project_id, :icon
  belongs_to :project
  acts_as_list :scope => :project
  has_many :records
  validates :name, :uniqueness => { :scope => :project_id, :message => "You cannot have several stages of a project with the same name."}
  delegate :user, :to => :project
  def update_position(p)
    self.save!
    self.remove_from_list
    self.insert_at p
    self
  end

end
