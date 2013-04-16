class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  has_many :projects
  has_many :stages, :through => :projects
  has_many :records, :through => :stages
  # attr_accessible :title, :body
  validates_presence_of :name

  def first_stages
    projects.map {|project|
      project.first_stage
    }
  end
end
