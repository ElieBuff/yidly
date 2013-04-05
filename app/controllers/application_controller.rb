class ApplicationController < ActionController::Base
  before_filter :set_access_control_headers

  def set_access_control_headers 
    headers['Access-Control-Allow-Origin'] = '*.herokuapp.com' 
    headers['Access-Control-Request-Method'] = '*.herokuapp.com' 
  end
  protect_from_forgery
end
