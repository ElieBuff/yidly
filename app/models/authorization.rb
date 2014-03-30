class Authorization < ActiveRecord::Base
  attr_accessible :name, :provider, :secret, :token, :uid, :url, :user_id
  belongs_to :user
end
