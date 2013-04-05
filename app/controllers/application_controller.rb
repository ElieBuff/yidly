class ApplicationController < ActionController::Base
  before_filter :set_access_control_headers

  def set_access_control_headers 
    headers['Access-Control-Allow-Origin'] = 'http://yidly-dashboard-local.herokuapp.com'
    headers['Access-Control-Request-Method'] = '*' 
  end
  protect_from_forgery
end
